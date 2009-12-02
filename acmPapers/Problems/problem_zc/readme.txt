本次作业的内容如下：

readme.txt      作业说明（您正在看的文件）

试题.doc        试题文本
设计报告.doc    试题设计说明报告

trade.doc       第一题解题报告
trade.pas       第一题参考源程序（含注释）
fire.doc        第二题解题报告
fire.pas        第二题参考源程序（含注释）
house.doc       第三题解题报告
house.pas       第三题参考源程序（含注释）

test.bat        自动测试程序（用法见后）
solve.bat       标准输出生成程序（不建议使用）

trade\input.*   第一题测试数据
trade\output.*  第一题参考输出
trade\data.pas  第一题数据生成程序（不建议使用）
trade\mark.pas  第一题评分程序（不建议使用）

fire\input.*    第二题测试数据
fire\output.*   第二题参考输出
fire\data.pas   第二题数据生成程序（不建议使用）
fire\mark.pas   第二题评分程序（不建议使用）

house\input.*   第三题测试数据
house\output.*  第三题参考输出
house\standard.*第三题标准解
house\data.pas  第三题数据生成程序（不建议使用）
house\mark.pas  第三题评分程序（不建议使用）

自动测试程序用法：

1. 测试全部程序
   test

2. 测试某一题
   test <题目名称>
   例如：test trade

3. 测试某一个数据
   test <题目名称> <测试数据编号>
   例如：test trade 001
   每题的测试数据编号为001～010

运行测试程序时，测试程序本身(test.bat)和待测试的可执行文件(*.exe)均要在当前目录下。
测试程序将自动拷贝测试数据，运行待测试程序，并调用相应的评分程序给出分数。
评分程序的容错性尚未经过全面测试，因此凡是无法让评分程序输出Correct信息的结果均应视为0分。

                                                        张辰
                                                      2000.4.30