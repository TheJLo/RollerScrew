#!/usr/bin/env python3

import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description = 'Test script for SRGL Parts')
    parser.add_argument('file', type=str, help='File to be tested')
    args = parser.parse_args()

    if not args.file:
        parser.print_help()
        sys.exit(1)

    run_file = args.file

    print('Testing %s' % run_file)
