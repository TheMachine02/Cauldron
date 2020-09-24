# Cauldron

Cauldron is a boot patch for hardware revision pre M (or boot code inferior or egal to 5.3.1)
It removes :
- OS verification at boot (boot 5.3.1)
- Minimal version installation is set permanently to 5.3.1 (both 5.1.5 and 5.3.1)
- Make the whole OS about 0.3% faster by removing some useless checkup

## WARNINGS : FATAL

DO NOT USE. It may induce various fatal error in the toolchain

## Warnings

This program tamper with the boot code of the calculator. As such, a failure during the execution of the program could lead to a corrupted boot code. Based on the corruption, it may fully brick the calculator without any possibilities to recover.
As such, the following should be carefully enforced :

- Do NOT reset the calculator while running the program
- Do NOT try to shutdown while running the program
- Let the program finish completely before trying to do something

Use at your own risk.

## How to run

Just launch the program. It may error out with Error:Break. This is perfectly normal. The patch has still been applied.

## Acknowledgement

This program is almost completely based on code from Ne3s2-3p4.
Ne3s2-3p4 and I shall not be held responsible for any damages done to the calculator.
