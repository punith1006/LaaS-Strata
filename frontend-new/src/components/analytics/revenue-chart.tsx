"use client";

import React, { useEffect, useRef } from 'react';
import { createChart, ColorType, AreaSeries, HistogramSeries } from 'lightweight-charts';

interface RevenueChartProps {
  height?: number;
}

// Generate 30 days of line data for revenue
const generateMockLineData = () => {
  const data = [];
  const baseDate = new Date('2025-05-01');

  for (let i = 0; i < 30; i++) {
    const date = new Date(baseDate);
    date.setDate(baseDate.getDate() + i);
    const dayOfWeek = date.getDay();
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

    const baseRevenue = isWeekend ? 4500 : 8000;
    const variance = isWeekend ? 2000 : 3500;
    const value = baseRevenue + Math.random() * variance;

    data.push({
      time: date.toISOString().split('T')[0],
      value: Math.round(value),
    });
  }
  return data;
};

// Volume bars colored green/red based on comparison with previous day
const generateMockVolumeData = (lineData: { time: string; value: number }[]) => {
  return lineData.map((item, index) => ({
    time: item.time,
    value: item.value,
    color: index === 0 ? '#10b981' : (item.value >= lineData[index - 1].value ? '#10b981' : '#ef4444'),
  }));
};

export function RevenueChart({ height = 240 }: RevenueChartProps) {
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<any>(null);

  useEffect(() => {
    if (!chartContainerRef.current) return;

    const chart = createChart(chartContainerRef.current, {
      layout: {
        background: { type: ColorType.Solid, color: '#141414' },
        textColor: '#a1a1aa',
      },
      width: chartContainerRef.current.clientWidth,
      height: height,
      timeScale: {
        timeVisible: false,
        borderColor: '#27272a',
      },
      rightPriceScale: {
        borderColor: '#27272a',
        scaleMargins: {
          top: 0.1,
          bottom: 0.3,
        },
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

    // Area series (line + blue gradient fill matching Daily Spend chart)
    const lineSeries = chart.addSeries(AreaSeries, {
      lineColor: '#3a73ff',
      topColor: 'rgba(58, 115, 255, 0.3)',
      bottomColor: 'rgba(58, 115, 255, 0.05)',
      lineWidth: 2,
      crosshairMarkerVisible: true,
      lastValueVisible: true,
      priceLineVisible: false,
    });

    const lineData = generateMockLineData();
    lineSeries.setData(lineData);

    // Volume histogram series (bottom 20%)
    const volumeSeries = chart.addSeries(HistogramSeries, {
      priceScaleId: '',
      priceFormat: { type: 'volume' },
    });

    volumeSeries.priceScale().applyOptions({
      scaleMargins: {
        top: 0.75,
        bottom: 0.05,
      },
    });

    const volumeData = generateMockVolumeData(lineData);
    volumeSeries.setData(volumeData);

    // Fit to content
    chart.timeScale().fitContent();

    // Resize handler
    const handleResize = () => {
      if (chartContainerRef.current) {
        chart.applyOptions({
          width: chartContainerRef.current.clientWidth,
        });
      }
    };

    window.addEventListener('resize', handleResize);

    return () => {
      window.removeEventListener('resize', handleResize);
      chart.remove();
    };
  }, [height]);

  return (
    <div className="w-full overflow-hidden rounded" style={{ height: `${height}px` }}>
      <div
        ref={chartContainerRef}
        className="w-full h-full [&_a]:!hidden [&_img]:!hidden [&_div[class*='logo']]:!hidden"
      />
    </div>
  );
}
