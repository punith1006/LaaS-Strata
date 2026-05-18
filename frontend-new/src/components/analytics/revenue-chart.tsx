"use client";

import React, { useEffect, useRef, useState } from 'react';
import { createChart, ColorType, AreaSeries, HistogramSeries, type UTCTimestamp, type IChartApi, type ISeriesApi } from 'lightweight-charts';
import { getAnalyticsAccessToken } from '@/lib/token';

const API_BASE = process.env.NEXT_PUBLIC_API_URL || "";
const IST_OFFSET_SECONDS = 5.5 * 3600; // 19800s — shift UTC timestamps to IST for display

interface RevenueChartProps {
  height?: number;
  timeRange: "24H" | "7D" | "30D" | "All";
  onDataLoaded?: (data: {
    ohlc: { open: number; high: number; low: number; close: number };
    currentRate: number;
    rateChange: number;
    rateChangePct: number;
  }) => void;
}

export function RevenueChart({ height = 240, timeRange, onDataLoaded }: RevenueChartProps) {
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<IChartApi | null>(null);
  const lineSeriesRef = useRef<ISeriesApi<'Area'> | null>(null);
  const volumeSeriesRef = useRef<ISeriesApi<'Histogram'> | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!chartContainerRef.current) return;

    const container = chartContainerRef.current;

    // Create chart instance
    const chart = createChart(container, {
      layout: {
        background: { type: ColorType.Solid, color: '#141414' },
        textColor: '#a1a1aa',
      },
      width: container.clientWidth,
      height: height,
      timeScale: {
        timeVisible: timeRange === "24H",
        borderColor: '#27272a',
      },
      rightPriceScale: {
        borderColor: '#27272a',
        scaleMargins: { top: 0.1, bottom: 0.3 },
      },
      grid: {
        vertLines: { color: '#1a1a1a' },
        horzLines: { color: '#1a1a1a' },
      },
      crosshair: {
        vertLine: { color: '#3a73ff', width: 1, style: 2 },
        horzLine: { color: '#3a73ff', width: 1, style: 2 },
      },
    });
    chartRef.current = chart;

    // Area series (blue gradient)
    const lineSeries = chart.addSeries(AreaSeries, {
      lineColor: '#3a73ff',
      topColor: 'rgba(58, 115, 255, 0.3)',
      bottomColor: 'rgba(58, 115, 255, 0.05)',
      lineWidth: 2,
      crosshairMarkerVisible: true,
      lastValueVisible: true,
      priceLineVisible: false,
    });
    lineSeriesRef.current = lineSeries;

    // Volume histogram (bottom 20%)
    const volumeSeries = chart.addSeries(HistogramSeries, {
      priceScaleId: '',
      priceFormat: { type: 'volume' },
    });
    volumeSeries.priceScale().applyOptions({
      scaleMargins: { top: 0.75, bottom: 0.05 },
    });
    volumeSeriesRef.current = volumeSeries;

    // Fetch real data
    const token = getAnalyticsAccessToken();
    if (!token) {
      setError('Not authenticated');
      setLoading(false);
      return () => { chart.remove(); };
    }

    fetch(`${API_BASE}/api/dashboard/analytics/revenue-chart?timeRange=${timeRange}`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then(res => res.ok ? res.json() : Promise.reject(`HTTP ${res.status}`))
      .then((data: { series: Array<{ time: number; value: number }>; ohlc: { open: number; high: number; low: number; close: number }; currentRate: number; rateChange: number; rateChangePct: number }) => {
        if (!data.series || data.series.length === 0) {
          setError('No revenue data for this period');
          setLoading(false);
          return;
        }

        // Map to chart format
        // First, add IST offset to shift timestamps for display
        const rawData = data.series.map(p => ({
          time: p.time + IST_OFFSET_SECONDS,
          value: p.value,
        }));

        // Re-bucket data into IST-aligned hours
        // The backend returns UTC-hour buckets, but we need to regroup them into IST-hour buckets
        const istHourSeconds = 3600;
        const reBucketedMap = new Map<number, number>();
        
        for (const point of rawData) {
          // Align to IST hour boundary
          const istAlignedTime = point.time - (point.time % istHourSeconds);
          const existing = reBucketedMap.get(istAlignedTime) || 0;
          reBucketedMap.set(istAlignedTime, existing + point.value);
        }

        // Convert back to sorted array
        const lineData = Array.from(reBucketedMap.entries())
          .map(([time, value]) => ({ time: time as UTCTimestamp, value }))
          .sort((a, b) => a.time - b.time);

        // Volume bars: delta indicator (BTC-style)
        // Height = absolute change from previous point; color = direction of change
        const volumeData = lineData.map((item, index) => ({
          time: item.time,
          value: index === 0 ? 0 : Math.abs(item.value - lineData[index - 1].value),
          color: index === 0
            ? '#10b981'
            : (item.value >= lineData[index - 1].value ? '#10b981' : '#ef4444'),
        }));

        lineSeries.setData(lineData);
        volumeSeries.setData(volumeData);
        chart.timeScale().fitContent();

        // Notify parent of OHLC data
        if (onDataLoaded) {
          onDataLoaded({
            ohlc: data.ohlc,
            currentRate: data.currentRate,
            rateChange: data.rateChange,
            rateChangePct: data.rateChangePct,
          });
        }

        setLoading(false);
      })
      .catch(err => {
        console.error('[RevenueChart] fetch error:', err);
        setError('Failed to load revenue data');
        setLoading(false);
      });

    // Resize handler
    const handleResize = () => {
      if (container) {
        chart.applyOptions({ width: container.clientWidth });
      }
    };
    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      chart.remove();
    };
  }, [height, timeRange, onDataLoaded]);

  if (error) {
    return (
      <div className="w-full flex items-center justify-center text-zinc-500 text-sm" style={{ height: `${height}px` }}>
        {error}
      </div>
    );
  }

  return (
    <div className="w-full overflow-hidden rounded relative" style={{ height: `${height}px` }}>
      {loading && (
        <div className="absolute inset-0 flex items-center justify-center bg-[#141414]/80 z-10">
          <span className="text-zinc-500 text-sm">Loading chart…</span>
        </div>
      )}
      <div
        ref={chartContainerRef}
        className="w-full h-full [&_a]:!hidden [&_img]:!hidden [&_div[class*='logo']]:!hidden"
      />
    </div>
  );
}
