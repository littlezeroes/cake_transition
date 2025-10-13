import { test, expect } from '@playwright/test';

test.describe('Basic Navigation Tests', () => {
  test('app loads successfully', async ({ page }) => {
    // Navigate to the deployed app
    await page.goto('https://example-8qftjzldl-huy-kieus-projects.vercel.app');
    
    // Wait for Flutter to fully load
    await page.waitForTimeout(3000);
    
    // Take a screenshot for verification
    await page.screenshot({ path: 'app-loaded.png' });
    
    // Check that the page has content
    const content = await page.textContent('body');
    expect(content).toBeTruthy();
  });

  test('captures transition screenshots', async ({ page }) => {
    await page.goto('https://example-8qftjzldl-huy-kieus-projects.vercel.app');
    
    // Wait for initial load
    await page.waitForTimeout(2000);
    
    // Capture initial state
    await page.screenshot({ path: 'screenshots/1-initial.png', fullPage: true });
    
    // Wait for navbar animation to complete
    await page.waitForTimeout(1000);
    await page.screenshot({ path: 'screenshots/2-navbar-visible.png', fullPage: true });
    
    // Try to interact with the page (click in the middle to see if pills are there)
    await page.mouse.click(400, 300);
    await page.waitForTimeout(500);
    await page.screenshot({ path: 'screenshots/3-after-click.png', fullPage: true });
  });

  test('measures page load time', async ({ page }) => {
    const startTime = Date.now();
    
    await page.goto('https://example-8qftjzldl-huy-kieus-projects.vercel.app');
    await page.waitForLoadState('networkidle');
    
    const loadTime = Date.now() - startTime;
    console.log(`Page load time: ${loadTime}ms`);
    
    // Page should load within 10 seconds
    expect(loadTime).toBeLessThan(10000);
  });
});