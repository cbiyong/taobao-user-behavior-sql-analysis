-- =============================================
-- 淘宝用户行为数据分析 SQL脚本
-- 数据表：user_behavior
-- 字段：user_id,item_id,category_id,behavior_type,time
-- behavior_type：1点击，2收藏，3加购，4购买
-- =============================================

-- ======================
-- 1.数据概览：查看样本10行
-- ======================
SELECT * FROM user_behavior LIMIT 10;

-- ======================
-- 2.统计数据集大盘：总行为、独立用户UV、商品数、分类数
-- ======================
SELECT
  COUNT(*) AS total_behavior,
  COUNT(DISTINCT user_id) AS uv,
  COUNT(DISTINCT item_id) AS item_count,
  COUNT(DISTINCT category_id) AS category_count
FROM user_behavior;

-- ======================
-- 3.各类行为数量统计（点击/收藏/加购/购买）
-- ======================
SELECT
  behavior_type,
  CASE behavior_type
    WHEN 1 THEN '点击'
    WHEN 2 THEN '收藏'
    WHEN 3 THEN '加购'
    WHEN 4 THEN '购买'
  END AS behavior_name,
  COUNT(*) AS behavior_cnt
FROM user_behavior
GROUP BY behavior_type
ORDER BY behavior_type;

-- ======================
-- 4.计算转化漏斗以及各环节转化率
-- ======================
WITH behavior_stat AS (
SELECT
  SUM(IF(behavior_type=1,1,0)) AS click_cnt,
  SUM(IF(behavior_type=2,1,0)) AS collect_cnt,
  SUM(IF(behavior_type=3,1,0)) AS cart_cnt,
  SUM(IF(behavior_type=4,1,0)) AS buy_cnt
FROM user_behavior
)
SELECT
  click_cnt,
  collect_cnt,
  cart_cnt,
  buy_cnt,
  ROUND(collect_cnt / click_cnt,4) AS collect_rate,
  ROUND(cart_cnt / click_cnt,4) AS cart_rate,
  ROUND(buy_cnt / click_cnt,4) AS buy_rate
FROM behavior_stat;

-- ======================
-- 5.时间维度：每日UV、每日总行为数
-- ======================
SELECT
  DATE(time) AS day,
  COUNT(DISTINCT user_id) AS daily_uv,
  COUNT(*) AS daily_behavior_cnt
FROM user_behavior
GROUP BY day
ORDER BY day;

-- ======================
-- 6.商品维度：购买TOP20商品
-- ======================
SELECT
  item_id,
  COUNT(*) AS buy_times
FROM user_behavior
WHERE behavior_type = 4
GROUP BY item_id
ORDER BY buy_times DESC
LIMIT 20;

-- ======================
-- 7.类目维度：各分类购买量TOP20
-- ======================
SELECT
  category_id,
  COUNT(*) AS buy_cnt
FROM user_behavior
WHERE behavior_type=4
GROUP BY category_id
ORDER BY buy_cnt DESC
LIMIT 20;

-- ======================
-- 8.用户维度：用户购买次数分布
-- ======================
WITH user_buy AS (
SELECT user_id,COUNT(*) AS buy_count
FROM user_behavior
WHERE behavior_type=4
GROUP BY user_id
)
SELECT
  buy_count,
  COUNT(user_id) AS user_num
FROM user_buy
GROUP BY buy_count
ORDER BY buy_count;

-- ======================
-- 9.计算复购用户 & 复购率
-- 复购用户：至少购买2次及以上
-- ======================
WITH user_buy AS (
SELECT user_id,COUNT(*) AS buy_cnt
FROM user_behavior
WHERE behavior_type=4
GROUP BY user_id
)
SELECT
  COUNT(user_id) AS total_buy_user,
  SUM(IF(buy_cnt>=2,1,0)) AS repeat_user,
  ROUND(SUM(IF(buy_cnt>=2,1,0)) / COUNT(user_id),4) AS repeat_rate
FROM user_buy;
