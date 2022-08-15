% 组合表格数据
% CALLER:  MultXlsIntoOne.m
% 手动处理并保存readdata生成的xls为xlsx
clear,clc
inputFolder = 'D:\Papers\cscd_MLD\Data\ProcessedData\season'
outputFolder = 'D:\Papers\cscd_MLD\Data\ProcessedData\FinalXls'
outputFileName = 'linklist.xlsx';
MultXlsIntoOne(inputFolder,outputFolder,outputFileName)
