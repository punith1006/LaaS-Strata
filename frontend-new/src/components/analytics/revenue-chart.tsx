"use client";

import React, { useEffect, useRef } from 'react';
import { createChart, ColorType, AreaSeries, HistogramSeries, type UTCTimestamp } from 'lightweight-charts';

interface RevenueChartProps {
  height?: number;
  timeRange: "24H" | "7D" | "30D" | "All";
}

// Generate 90 days of hourly revenue data — aligned to billing capture cadence.
// Billing logic: charges are captured at the top of every hour (00:00, 01:00, …).
// When a session starts, the first hour is charged upfront; subsequent hours
// are billed on the dot.  Each data-point therefore represents the total
// revenue collected across all active sessions at that hour.
const generateRawHourlyData = () => {
  const data = [];
  const baseDate = new Date('2025-05-01T00:00:00Z');

  for (let i = 0; i < 90; i++) {
    for (let h = 0; h < 24; h++) {
      const date = new Date(baseDate);
      date.setDate(baseDate.getDate() + i);
      date.setUTCHours(h, 0, 0, 0);
      const dayOfWeek = date.getUTCDay();
      const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;

      // Session density varies by hour — mirrors real usage patterns
      let sessionScale: number;
      if (h >= 9 && h <= 18) {
        sessionScale = 1.0;                     // peak (business hours)
      } else if ((h >= 6 && h < 9) || (h > 18 && h <= 22)) {
        sessionScale = 0.6;                     // moderate (shoulders)
      } else {
        sessionScale = 0.25;                    // low (night)
      }
      if (isWeekend) sessionScale *= 0.5;

      // ~20 concurrent sessions at peak, each averaging ₹200/hr
      const activeSessions = Math.round(20 * sessionScale + Math.random() * 5);
      const avgHourlyRate = 180 + Math.random() * 80; // ₹180–260 per session
      const hourlyRevenue = activeSessions * avgHourlyRate;

      data.push({
        time: Math.floor(date.getTime() / 1000) as UTCTimestamp,
        value: Math.round(hourlyRevenue),
      });
    }
  }
  return data;
};

// Get batch size (number of aggregated data points) per timeRange
const getBatchSize = (timeRange: "24H" | "7D" | "30D" | "All"): number => {
  switch (timeRange) {
    case "24H": return 24;
    case "7D": return 42;
    case "30D": return 60;
    case "All": return 30;
  }
};

// Get bucket size for aggregation per timeRange
const getBucketSize = (timeRange: "24H" | "7D" | "30D" | "All"): number => {
  switch (timeRange) {
    case "24H": return 1;  // no aggregation
    case "7D": return 4;   // average every 4 hours
    case "30D": return 12;  // average every 12 hours
    case "All": return 24;  // average every 24 hours
  }
};

// Aggregate the full raw hourly pool into the desired bucket size
const aggregateFullPool = (raw: { time: UTCTimestamp; value: number }[], timeRange: "24H" | "7D" | "30D" | "All") => {
  const bucketSize = getBucketSize(timeRange);

  if (bucketSize === 1) return raw;

  const aggregated: { time: UTCTimestamp; value: number }[] = [];
  for (let i = 0; i < raw.length; i += bucketSize) {
    const bucket = raw.slice(i, i + bucketSize);
    if (bucket.length === 0) break;
    const avg = Math.round(bucket.reduce((sum, d) => sum + d.value, 0) / bucket.length);
    aggregated.push({ time: bucket[0].time, value: avg });
  }

  return aggregated;
};

// Volume bars: green if this hour's collection >= previous hour, red otherwise
const generateMockVolumeData = (lineData: { time: UTCTimestamp; value: number }[]) => {
  return lineData.map((item, index) => ({
    time: item.time,
    value: item.value,
    color: index === 0 ? '#10b981' : (item.value >= lineData[index - 1].value ? '#10b981' : '#ef4444'),
  }));
};

export function RevenueChart({ height = 240, timeRange }: RevenueChartProps) {
  const chartContainerRef = useRef<HTMLDivElement>(null);
  const chartRef = useRef<any>(null);
  const lineSeriesRef = useRef<any>(null);
  const volumeSeriesRef = useRef<any>(null);
  const batchesLoadedRef = useRef(2);
  const aggregatedDataRef = useRef<{ time: UTCTimestamp; value: number }[]>([]);
  const isLoadingRef = useRef(false);

  useEffect(() => {
    if (!chartContainerRef.current) return;

    // Generate and aggregate the full 90-day pool once
    const rawPool = generateRawHourlyData();
    const fullAggregated = aggregateFullPool(rawPool, timeRange);
    aggregatedDataRef.current = fullAggregated;

    const batchSize = getBatchSize(timeRange);
    const maxBatches = Math.floor(fullAggregated.length / batchSize);
    const initialBatches = Math.min(2, maxBatches);
    batchesLoadedRef.current = initialBatches;
    isLoadingRef.current = false;

    // Initial data: last (initialBatches * batchSize) points from the full pool
    const initialPoints = initialBatches * batchSize;
    const lineData = fullAggregated.slice(-initialPoints);
    const volumeData = generateMockVolumeData(lineData);

    const chart = createChart(chartContainerRef.current, {
      layout: {
        background: { type: ColorType.Solid, color: '#141414' },
        textColor: '#a1a1aa',
      },
      width: chartContainerRef.current.clientWidth,
      height: height,
      timeScale: {
        timeVisible: timeRange === "24H",
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

    lineSeries.setData(lineData);
    lineSeriesRef.current = lineSeries;

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

    volumeSeries.setData(volumeData);
    volumeSeriesRef.current = volumeSeries;

    // Fit to content, then show only the rightmost batch (current period)
    chart.timeScale().fitContent();
    chart.timeScale().setVisibleLogicalRange({
      from: lineData.length - batchSize,
      to: lineData.length - 1,
    });

    // Subscribe to visible range changes for lazy-loading
    chart.timeScale().subscribeVisibleLogicalRangeChange((range: any) => {
      if (!range) return;
      if (isLoadingRef.current) return;

      // If the left edge of visible range is within 5 bars of loaded data start
      if (range.from <= 5) {
        const currentBatches = batchesLoadedRef.current;
        const currentMaxBatches = Math.floor(aggregatedDataRef.current.length / batchSize);

        if (currentBatches >= currentMaxBatches) return; // no more data

        isLoadingRef.current = true;

        const newBatches = Math.min(currentBatches + 1, currentMaxBatches);
        batchesLoadedRef.current = newBatches;

        const newPointCount = newBatches * batchSize;
        const newLineData = aggregatedDataRef.current.slice(-newPointCount);
        const newVolumeData = generateMockVolumeData(newLineData);

        // Update series data — chart maintains scroll position automatically
        if (lineSeriesRef.current) lineSeriesRef.current.setData(newLineData);
        if (volumeSeriesRef.current) volumeSeriesRef.current.setData(newVolumeData);

        // Debounce to prevent rapid-fire loads
        setTimeout(() => { isLoadingRef.current = false; }, 300);
      }
    });

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
  }, [height, timeRange]);

  return (
    <div className="w-full overflow-hidden rounded" style={{ height: `${height}px` }}>
      <div
        ref={chartContainerRef}
        className="w-full h-full [&_a]:!hidden [&_img]:!hidden [&_div[class*='logo']]:!hidden"
      />
    </div>
  );
}
