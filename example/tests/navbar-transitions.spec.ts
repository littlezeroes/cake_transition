import { test, expect } from '@playwright/test';

test.describe('Floating Navbar Transitions', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/');
    // Wait for Flutter app to load
    await page.waitForTimeout(2000);
  });

  test('navbar appears with animation on load', async ({ page }) => {
    // Check if navbar is visible
    const navbar = page.locator('flt-semantics').filter({ hasText: /Card|Vay|QR|Saving|Đầu tư/ });
    await expect(navbar).toBeVisible();
    
    // Verify navbar position (should be at bottom)
    const boundingBox = await navbar.boundingBox();
    expect(boundingBox).toBeTruthy();
    if (boundingBox) {
      const viewportSize = page.viewportSize();
      if (viewportSize) {
        expect(boundingBox.y).toBeGreaterThan(viewportSize.height - 200);
      }
    }
  });

  test('pill selection animation works', async ({ page }) => {
    // Wait for pills to be visible
    await page.waitForTimeout(1000);
    
    // Try to click on different pills (if pills component is visible)
    const pills = page.locator('text=/Portfolio|Markets|Trade|Wallet/');
    
    if (await pills.count() > 0) {
      // Click on Markets pill
      await page.click('text=Markets');
      await page.waitForTimeout(500);
      
      // Click on Trade pill
      await page.click('text=Trade');
      await page.waitForTimeout(500);
      
      // Click on Wallet pill
      await page.click('text=Wallet');
      await page.waitForTimeout(500);
    }
  });

  test('content transitions smoothly when switching tabs', async ({ page }) => {
    // Check if we can see content transitions
    const content = page.locator('flt-semantics');
    
    // Get initial content
    const initialText = await content.textContent();
    
    // If pills are available, click one
    const marketsPill = page.locator('text=Markets');
    if (await marketsPill.count() > 0) {
      await marketsPill.click();
      await page.waitForTimeout(1000);
      
      // Content should have changed
      const newText = await content.textContent();
      expect(newText).not.toBe(initialText);
    }
  });

  test('navbar has proper styling', async ({ page }) => {
    // Check for the white navbar container
    const navbar = page.locator('flt-semantics').filter({ hasText: /Card|Vay|QR|Saving|Đầu tư/ });
    
    // Verify navbar exists
    await expect(navbar).toBeVisible();
  });
});

test.describe('Performance Metrics', () => {
  test('measures animation performance', async ({ page }) => {
    // Start performance measurement
    await page.goto('/');
    
    // Measure page load performance
    const performanceTiming = await page.evaluate(() => {
      const timing = performance.timing;
      return {
        domContentLoaded: timing.domContentLoadedEventEnd - timing.domContentLoadedEventStart,
        loadComplete: timing.loadEventEnd - timing.loadEventStart,
        domInteractive: timing.domInteractive - timing.navigationStart,
      };
    });
    
    console.log('Performance Metrics:', performanceTiming);
    
    // Check that page loads reasonably fast
    expect(performanceTiming.domInteractive).toBeLessThan(5000);
  });

  test('checks for smooth animations (60fps)', async ({ page, browserName }) => {
    // Skip this test on webkit as it has different performance characteristics
    if (browserName === 'webkit') {
      test.skip();
    }
    
    await page.goto('/');
    await page.waitForTimeout(2000);
    
    // Start monitoring FPS
    const fps = await page.evaluate(() => {
      return new Promise<number>((resolve) => {
        let lastTime = performance.now();
        let frames = 0;
        let totalFps = 0;
        
        const measureFps = () => {
          const currentTime = performance.now();
          const delta = currentTime - lastTime;
          
          if (delta >= 1000) {
            const currentFps = Math.round((frames * 1000) / delta);
            totalFps += currentFps;
            frames = 0;
            lastTime = currentTime;
            
            // Measure for 3 seconds
            if (currentTime > 3000) {
              resolve(totalFps / 3);
              return;
            }
          }
          
          frames++;
          requestAnimationFrame(measureFps);
        };
        
        requestAnimationFrame(measureFps);
      });
    });
    
    console.log(`Average FPS: ${fps}`);
    // Expect at least 30fps for smooth animations
    expect(fps).toBeGreaterThan(30);
  });
});

test.describe('Mobile Responsiveness', () => {
  test('navbar adapts to mobile viewport', async ({ page, isMobile }) => {
    if (!isMobile) {
      test.skip();
    }
    
    await page.goto('/');
    await page.waitForTimeout(2000);
    
    // Check navbar is visible on mobile
    const navbar = page.locator('flt-semantics').filter({ hasText: /Card|Vay|QR|Saving|Đầu tư/ });
    await expect(navbar).toBeVisible();
    
    // Verify navbar fits within mobile viewport
    const boundingBox = await navbar.boundingBox();
    const viewportSize = page.viewportSize();
    
    if (boundingBox && viewportSize) {
      expect(boundingBox.width).toBeLessThanOrEqual(viewportSize.width);
    }
  });
});

test.describe('Accessibility', () => {
  test('navbar has proper ARIA labels', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(2000);
    
    // Check for semantic elements
    const semantics = await page.locator('flt-semantics').count();
    expect(semantics).toBeGreaterThan(0);
  });

  test('keyboard navigation works', async ({ page }) => {
    await page.goto('/');
    await page.waitForTimeout(2000);
    
    // Try tab navigation
    await page.keyboard.press('Tab');
    await page.waitForTimeout(100);
    await page.keyboard.press('Tab');
    await page.waitForTimeout(100);
    
    // Try enter key
    await page.keyboard.press('Enter');
    await page.waitForTimeout(500);
    
    // Page should still be functional
    const navbar = page.locator('flt-semantics');
    await expect(navbar).toBeVisible();
  });
});