'use strict';
// Numeric form input must never execute JavaScript.
module.exports = function numericInput(value) {
    if (value === undefined || value === null) return value;
    const text = String(value).trim();
    if (!text) return undefined;
    if (!/^[+-]?(?:\d+\.?\d*|\.\d+)(?:e[+-]?\d+)?$/i.test(text) || !Number.isFinite(Number(text))) {
        const err = new Error('Invalid numeric input.');
        err.status = 400;
        throw err;
    }
    return Number(text);
};
