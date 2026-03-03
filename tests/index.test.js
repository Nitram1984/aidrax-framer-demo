import { describe, expect, it } from 'vitest';
import fs from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const indexPath = path.join(root, 'index.html');
const cssPath = path.join(root, 'aidrax-neon.css');

describe('AIDRAX demo smoke tests', () => {
  it('has an index.html file', () => {
    expect(fs.existsSync(indexPath)).toBe(true);
  });

  it('references the neon stylesheet', () => {
    const html = fs.readFileSync(indexPath, 'utf8');
    expect(html).toContain('aidrax-neon.css');
  });

  it('contains expected AIDRAX UI text', () => {
    const html = fs.readFileSync(indexPath, 'utf8');

    expect(html).toContain('AIDRAX Neon Browser');
    expect(html).toContain('AIDRAX-Neon-Style');
    expect(html).toContain('Start');
  });

  it('has a stylesheet file', () => {
    expect(fs.existsSync(cssPath)).toBe(true);
  });
});
