%a = fileread('processed_sudoku_coverage.txt');
%fid = fopen('processed_sudoku_coverage.txt','rt');
%C = textscan(fid);
%fclose(fid);
%
a = load('processed_sudoku_coverage.txt')