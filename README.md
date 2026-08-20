# taobao-user-behavior-sql-analysis
淘宝用户行为数据集 SQL实战分析项目

### 项目介绍
使用MySQL对淘宝用户行为日志做业务数据分析。
原始csv通过Python pandas导入MySQL，完成大盘指标、转化漏斗、时间趋势、商品、用户复购分析。

### 文件说明
- `analysis.sql`：全部分析SQL脚本，可以直接在Navicat运行
- `analysis_report.md`：完整分析文档，包含每段SQL思路、函数解析、业务含义

### 技术栈
- MySQL8.0
- Python(Pandas)：csv数据导入数据库
- Navicat：SQL查询客户端
