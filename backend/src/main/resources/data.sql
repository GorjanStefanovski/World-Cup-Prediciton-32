-- ============================================================
-- 2026 FIFA World Cup - Round of 32 Teams
-- FIFA Rankings: June 11, 2026 (официјална листа пред турнирот)
-- team_form: просек на поени од 3 групни натпревари (победа=3, нерешено=1, пораз=0) / 3
-- rest_days: денови од последниот групен натпревар до R32 натпреварот
-- confederation rank: ранк во конфедерацијата
-- ============================================================

-- НАПОМЕНА ЗА rest_days:
-- Групната фаза завршила на 27 јуни.
-- R32 натпреварите се од 28 јуни до 3 јули 2026.
-- rest_days = датум на R32 - датум на последен групен натпревар

INSERT INTO teams (id, name, confederation, fifa_rank, fifa_points, still_in_tournament, rest_days, team_form, last_formation) VALUES

-- =====================
-- 28 ЈУНИ (Sunday)
-- South Africa vs Canada
-- =====================

-- Последна утакмица: South Africa 1-0 South Korea (24 јуни)
-- R32: 28 јуни → rest_days = 4
-- Групна фаза: Пораз 0-2 vs Mexico (0пт), Нерешено 1-1 vs Czechia (1пт), Победа 1-0 vs South Korea (3пт) → (0+1+3)/3 = 1.33
(1,  'South Africa','CAF',60,  1432.0, true, 4,  1.33, '4-4-2'),

-- Последна утакмица: Switzerland 3-1 Canada (24 јуни)
-- R32: 28 јуни → rest_days = 4
-- Групна фаза: Нерешено 1-1 vs Bosnia (1пт), Победа 6-0 vs Qatar (3пт), Пораз 1-3 vs Switzerland (0пт) → (1+3+0)/3 = 1.33
(2,'Canada','CONCACAF',  30,  1542.0, true, 4,  1.33, '4-3-3'),

-- =====================
-- 29 ЈУНИ (Monday)
-- Brazil vs Japan
-- Germany vs Paraguay
-- Netherlands vs Morocco
-- =====================

-- Последна утакмица: Brazil 3-0 Scotland (24 јуни)
-- R32: 29 јуни → rest_days = 5
-- Групна фаза: Нерешено 1-1 vs Morocco (1пт), Победа 3-0 vs Haiti (3пт), Победа 3-0 vs Scotland (3пт) → (1+3+3)/3 = 2.33
(3,  'Brazil',         'CONMEBOL',  6,   1837.0, true, 5,  2.33, '4-2-3-1'),

-- Последна утакмица: Japan 1-1 Sweden (25 јуни)
-- R32: 29 јуни → rest_days = 4
-- Групна фаза: Нерешено 2-2 vs Netherlands (1пт), Победа 4-0 vs Tunisia (3пт), Нерешено 1-1 vs Sweden (1пт) → (1+3+1)/3 = 1.67
(4,  'Japan',                'AFC',       18,  1593.0, true, 4,  1.67, '4-2-3-1'),

-- Последна утакмица: Ecuador 2-1 Germany (25 јуни)
-- R32: 29 јуни → rest_days = 4
-- Групна фаза: Победа 7-1 vs Curacao (3пт), Победа 2-1 vs Ivory Coast (3пт), Пораз 1-2 vs Ecuador (0пт) → (3+3+0)/3 = 2.0
(5,  'Germany',              'UEFA',      10,  1733.0, true, 4,  2.0,  '4-2-3-1'),

-- Последна утакмица: Paraguay 0-0 Australia (25 јуни)
-- R32: 29 јуни → rest_days = 4
-- Групна фаза: Пораз 1-4 vs USA (0пт), Победа 1-0 vs Turkey (3пт), Нерешено 0-0 vs Australia (1пт) → (0+3+1)/3 = 1.33
(6,  'Paraguay',             'CONMEBOL',  41,  1477.0, true, 4,  1.33, '4-4-2'),

-- Последна утакмица: Netherlands 3-1 Tunisia (25 јуни)
-- R32: 29 јуни → rest_days = 4
-- Групна фаза: Нерешено 2-2 vs Japan (1пт), Победа 5-1 vs Sweden (3пт), Победа 3-1 vs Tunisia (3пт) → (1+3+3)/3 = 2.33
(7,  'Netherlands',          'UEFA',      8,   1692.0, true, 4,  2.33, '4-3-3'),

-- Последна утакмица: Morocco 4-2 Haiti (24 јуни)
-- R32: 29 јуни → rest_days = 5
-- Групна фаза: Нерешено 1-1 vs Brazil (1пт), Победа 1-0 vs Scotland (3пт), Победа 4-2 vs Haiti (3пт) → (1+3+3)/3 = 2.33
(8,  'Morocco',              'CAF',       7,   1664.0, true, 5,  2.33, '4-3-3'),

-- =====================
-- 30 ЈУНИ (Tuesday)
-- France vs Sweden
-- Ivory Coast vs Norway
-- Mexico vs Ecuador
-- =====================

-- Последна утакмица: Norway 4-1 France (26 јуни)
-- R32: 30 јуни → rest_days = 4
-- Групна фаза: Победа 3-1 vs Senegal (3пт), Победа 3-0 vs Iraq (3пт), Пораз 1-4 vs Norway (0пт) → (3+3+0)/3 = 2.0
(9,  'France',               'UEFA',      3,   1768.0, true, 4,  2.0,  '4-3-3'),

-- Последна утакмица: Japan 1-1 Sweden (25 јуни)
-- R32: 30 јуни → rest_days = 5
-- Групна фаза: Победа 5-1 vs Tunisia (3пт), Пораз 1-5 vs Netherlands (0пт), Нерешено 1-1 vs Japan (1пт) → (3+0+1)/3 = 1.33
(10, 'Sweden',               'UEFA',      38,  1543.0, true, 5,  1.33, '4-4-2'),

-- Последна утакмица: Ivory Coast 2-0 Curacao (25 јуни)
-- R32: 30 јуни → rest_days = 5
-- Групна фаза: Пораз 0-1 vs Ecuador (0пт), Пораз 1-2 vs Germany (0пт), Победа 2-0 vs Curacao (3пт) → (0+0+3)/3 = 1.0
(11, 'Ivory Coast',          'CAF',       33,  1481.0, true, 5,  1.0,  '4-3-3'),

-- Последна утакмица: Norway 4-1 France (26 јуни)
-- R32: 30 јуни → rest_days = 4
-- Групна фаза: Победа 4-1 vs Iraq (3пт), Победа 3-2 vs Senegal (3пт), Победа 4-1 vs France (3пт) → (3+3+3)/3 = 3.0
(12, 'Norway',               'UEFA',      31,  1736.0, true, 4,  3.0,  '4-3-3'),

-- Последна утакмица: Mexico 3-0 Czechia (24 јуни)
-- R32: 30 јуни → rest_days = 6
-- Групна фаза: Победа 2-0 vs South Africa (3пт), Победа 1-0 vs South Korea (3пт), Победа 3-0 vs Czechia (3пт) → (3+3+3)/3 = 3.0
(13, 'Mexico',               'CONCACAF',  14,  1651.0, true, 6,  3.0,  '4-3-3'),

-- Последна утакмица: Ecuador 2-1 Germany (25 јуни)
-- R32: 30 јуни → rest_days = 5
(14, 'Ecuador',              'CONMEBOL',  23,  1475.0, true, 5,  1.33, '4-4-2'),

-- =====================
-- 1 ЈУЛИ (Wednesday)
-- England vs DR Congo
-- USA vs Bosnia & Herzegovina
-- Belgium vs Senegal
-- =====================

-- Последна утакмица: England 2-0 Panama (27 јуни)
-- R32: 1 јули → rest_days = 4
-- Групна фаза: Победа 4-2 vs Croatia (3пт), Нерешено 0-0 vs Ghana (1пт), Победа 2-0 vs Panama (3пт) → (3+1+3)/3 = 2.33
(15, 'England',              'UEFA',      4,   1764.0, true, 4,  2.33, '4-3-3'),

-- Последна утакмица: DR Congo 3-1 Uzbekistan (27 јуни)
-- R32: 1 јули → rest_days = 4
-- Групна фаза: Нерешено 1-1 vs Portugal (1пт), Пораз 0-1 vs Colombia (0пт), Победа 3-1 vs Uzbekistan (3пт) → (1+0+3)/3 = 1.33
(16, 'DR Congo',             'CAF',       46,  1374.0, true, 4,  1.33, '4-4-2'),

-- Последна утакмица: Turkey 3-2 USA (25 јуни)
-- R32: 1 јули → rest_days = 6
-- Групна фаза: Победа 4-1 vs Paraguay (3пт), Победа 2-0 vs Australia (3пт), Пораз 2-3 vs Turkey (0пт) → (3+3+0)/3 = 2.0
(17, 'USA',                  'CONCACAF',  17,  1627.0, true, 6,  2.0,  '4-3-3'),

-- Последна утакмица: Bosnia 3-1 Qatar (24 јуни)
-- R32: 1 јули → rest_days = 7
-- Групна фаза: Нерешено 1-1 vs Canada (1пт), Пораз 1-4 vs Switzerland (0пт), Победа 3-1 vs Qatar (3пт) → (1+0+3)/3 = 1.33
(18, 'Bosnia and Herzegovina','UEFA',     64,  1395.0, true, 7,  1.33, '4-3-3'),

-- Последна утакмица: Belgium 5-1 New Zealand (26 јуни)
-- R32: 1 јули → rest_days = 5
-- Групна фаза: Нерешено 1-1 vs Egypt (1пт), Нерешено 0-0 vs Iran (1пт), Победа 5-1 vs New Zealand (3пт) → (1+1+3)/3 = 1.67
(19, 'Belgium',              'UEFA',      9,   1710.0, true, 5,  1.67, '4-2-3-1'),

-- Последна утакмица: Senegal 5-0 Iraq (26 јуни)
-- R32: 1 јули → rest_days = 5
-- Групна фаза: Пораз 1-3 vs France (0пт), Пораз 2-3 vs Norway (0пт), Победа 5-0 vs Iraq (3пт) → (0+0+3)/3 = 1.0
(20, 'Senegal',              'CAF',       15,  1484.0, true, 5,  1.0,  '4-3-3'),

-- =====================
-- 2 ЈУЛИ (Thursday)
-- Portugal vs Croatia
-- Spain vs Austria
-- Switzerland vs Algeria
-- =====================

-- Последна утакмица: Colombia 0-0 Portugal (27 јуни)
-- R32: 2 јули → rest_days = 5
-- Групна фаза: Нерешено 1-1 vs DR Congo (1пт), Победа 5-0 vs Uzbekistan (3пт), Нерешено 0-0 vs Colombia (1пт) → (1+3+1)/3 = 1.67
(21, 'Portugal',             'UEFA',      5,   1746.0, true, 5,  1.67, '4-3-3'),

-- Последна утакмица: Croatia 2-1 Ghana (27 јуни)
-- R32: 2 јули → rest_days = 5
-- Групна фаза: Пораз 2-4 vs England (0пт), Победа 1-0 vs Panama (3пт), Победа 2-1 vs Ghana (3пт) → (0+3+3)/3 = 2.0
(22, 'Croatia',              'UEFA',      11,  1564.0, true, 5,  2.0,  '4-3-3'),

-- Последна утакмица: Spain 1-0 Uruguay (26 јуни)
-- R32: 2 јули → rest_days = 6
-- Групна фаза: Нерешено 0-0 vs Cape Verde (1пт), Победа 4-0 vs Saudi Arabia (3пт), Победа 1-0 vs Uruguay (3пт) → (1+3+3)/3 = 2.33
(23, 'Spain',                'UEFA',      2,   1840.0, true, 6,  2.33, '4-3-3'),

-- Последна утакмица: Austria 3-3 Algeria (27 јуни)
-- R32: 2 јули → rest_days = 5
-- Групна фаза: Победа 3-1 vs Jordan (3пт), Пораз 0-2 vs Argentina (0пт), Нерешено 3-3 vs Algeria (1пт) → (3+0+1)/3 = 1.33
(24, 'Austria',              'UEFA',      24,  1609.0, true, 5,  1.33, '4-3-3'),

-- Последна утакмица: Switzerland 3-1 Canada (24 јуни)
-- R32: 2 јули → rest_days = 8
-- Групна фаза: Нерешено 1-1 vs Qatar (1пт), Победа 4-1 vs Bosnia (3пт), Победа 3-1 vs Canada (3пт) → (1+3+3)/3 = 2.33
(25, 'Switzerland',          'UEFA',      19,  1638.0, true, 8,  2.33, '4-2-3-1'),

-- Последна утакмица: Austria 3-3 Algeria (27 јуни)
-- R32: 2 јули → rest_days = 5
-- Групна фаза: Пораз 0-3 vs Argentina (0пт), Победа 2-1 vs Jordan (3пт), Нерешено 3-3 vs Austria (1пт) → (0+3+1)/3 = 1.33
(26, 'Algeria',              'CAF',       28,  1446.0, true, 5,  1.33, '4-3-3'),

-- =====================
-- 3 ЈУЛИ (Friday)
-- Argentina vs Cape Verde
-- Colombia vs Ghana
-- Australia vs Egypt
-- =====================

-- Последна утакмица: Argentina 3-1 Jordan (27 јуни)
-- R32: 3 јули → rest_days = 6
-- Групна фаза: Победа 3-0 vs Algeria (3пт), Победа 2-0 vs Austria (3пт), Победа 3-1 vs Jordan (3пт) → (3+3+3)/3 = 3.0
(27, 'Argentina',            'CONMEBOL',  1,   1902.0, true, 6,  3.0,  '4-3-3'),

-- Последна утакмица: Cape Verde 0-0 Saudi Arabia (26 јуни)
-- R32: 3 јули → rest_days = 7
-- Групна фаза: Нерешено 0-0 vs Spain (1пт), Нерешено 2-2 vs Uruguay (1пт), Нерешено 0-0 vs Saudi Arabia (1пт) → (1+1+1)/3 = 1.0
(28, 'Cape Verde',           'CAF',       67,  1401.0, true, 7,  1.0,  '4-4-2'),

-- Последна утакмица: Colombia 0-0 Portugal (27 јуни)
-- R32: 3 јули → rest_days = 6
-- Групна фаза: Победа 3-1 vs Uzbekistan (3пт), Победа 1-0 vs DR Congo (3пт), Нерешено 0-0 vs Portugal (1пт) → (3+3+1)/3 = 2.33
(29, 'Colombia',             'CONMEBOL',  13,  1613.0, true, 6,  2.33, '4-2-3-1'),

-- Последна утакмица: Croatia 2-1 Ghana (27 јуни)
-- R32: 3 јули → rest_days = 6
-- Групна фаза: Победа 1-0 vs Panama (3пт), Нерешено 0-0 vs England (1пт), Пораз 1-2 vs Croatia (0пт) → (3+1+0)/3 = 1.33
(30, 'Ghana',                'CAF',       73,  1383.0, true, 6,  1.33, '4-4-2'),

-- Последна утакмица: Egypt 1-1 Iran (27 јуни)
-- R32: 3 јули → rest_days = 6
-- Групна фаза: Нерешено 1-1 vs Belgium (1пт), Победа 3-1 vs New Zealand (3пт), Нерешено 1-1 vs Iran (1пт) → (1+3+1)/3 = 1.67
(31, 'Egypt',                'CAF',       29,  1370.0, true, 6,  1.67, '4-2-3-1'),

-- Последна утакмица: Paraguay 0-0 Australia (25 јуни)
-- R32: 3 јули → rest_days = 8
-- Групна фаза: Пораз 0-2 vs Turkey (0пт), Победа 2-0 vs USA (3пт) -- чека...
-- Групна фаза: Пораз 0-2 vs Turkey (0пт), Победа 0-0 (нерешено vs Paraguay???) ...
-- Корекција: USA победи 2-0 Australia (19 јуни), Australia 0-0 Paraguay (25 јуни)
-- Australia: Пораз 2-0 vs Turkey (0пт), Пораз 0-2 vs USA (0пт), Нерешено 0-0 vs Paraguay (1пт) → (0+0+1)/3 = 0.33
(32, 'Australia',            'AFC',       27,  1556.0, true, 8,  0.33, '4-3-3');

-- ============================================================
-- БЕЛЕШКИ ЗА КОНФЕДЕРАЦИСКИ РАНГОВИ:
-- UEFA: Spain(2), France(3), England(4), Portugal(5), Germany(5), Netherlands(7), Belgium(6), Norway(4), Switzerland(8), Austria(9), Sweden(11), Croatia(12), Bosnia(14)
-- CONMEBOL: Argentina(1), Brazil(1), Colombia(2), Ecuador(3), Paraguay(4)
-- AFC: Japan(2), Australia(1)
-- CAF: Morocco(1), Ivory Coast(2), South Africa(4), Senegal(3), Algeria(6), DR Congo(5), Egypt(9), Ghana(8), Cape Verde(7)
-- CONCACAF: Mexico(1), USA(2), Canada(3)
-- ============================================================



-- ============================================================
-- 2026 FIFA World Cup - Round of 32 Натпревари
-- match_date: Македонско време (CEST = UTC+2)
-- ET → MK конверзија: +6 часа
-- home_team_id / away_team_id: соодветствуваат на teams_insert.sql
-- ============================================================

INSERT INTO matches (home_team_id, away_team_id, round, venue, match_date) VALUES

-- =====================
-- 28 ЈУНИ (Недела)
-- =====================

-- 21:00 МК | 15:00 ET | SoFi Stadium, Los Angeles
(2, 1, 'Round of 32', 'SoFi Stadium, Los Angeles', '2026-06-28T21:00:00'),

-- =====================
-- 29 ЈУНИ (Понеделник)
-- =====================

-- 19:00 МК | 13:00 ET | NRG Stadium, Houston
(3, 4, 'Round of 32', 'NRG Stadium, Houston', '2026-06-29T19:00:00'),

-- 22:30 МК | 16:30 ET | Gillette Stadium, Foxborough
(5, 6, 'Round of 32', 'Gillette Stadium, Foxborough', '2026-06-29T22:30:00'),

-- 03:00 МК (30 јуни) | 21:00 ET | Estadio BBVA, Monterrey
(7, 8, 'Round of 32', 'Estadio BBVA, Monterrey', '2026-06-30T03:00:00'),

-- =====================
-- 30 ЈУНИ (Вторник)
-- =====================

-- 19:00 МК | 13:00 ET | AT&T Stadium, Arlington
(11, 12, 'Round of 32', 'AT&T Stadium, Arlington', '2026-06-30T19:00:00'),

-- 23:00 МК | 17:00 ET | MetLife Stadium, East Rutherford
(9, 10, 'Round of 32', 'MetLife Stadium, East Rutherford', '2026-06-30T23:00:00'),

-- 03:00 МК (1 јули) | 21:00 ET | Estadio Azteca, Mexico City
(13, 14, 'Round of 32', 'Estadio Azteca, Mexico City', '2026-07-01T03:00:00'),

-- =====================
-- 1 ЈУЛИ (Среда)
-- =====================

-- 18:00 МК | 12:00 ET | Mercedes-Benz Stadium, Atlanta
(15, 16, 'Round of 32', 'Mercedes-Benz Stadium, Atlanta', '2026-07-01T18:00:00'),

-- 22:00 МК | 16:00 ET | Lumen Field, Seattle
(19, 20, 'Round of 32', 'Lumen Field, Seattle', '2026-07-01T22:00:00'),

-- 02:00 МК (2 јули) | 20:00 ET | Levi's Stadium, Santa Clara
(17, 18, 'Round of 32', 'Levi''s Stadium, Santa Clara', '2026-07-02T02:00:00'),

-- =====================
-- 2 ЈУЛИ (Четврток)
-- =====================

-- 21:00 МК | 15:00 ET | SoFi Stadium, Los Angeles
(23, 24, 'Round of 32', 'SoFi Stadium, Los Angeles', '2026-07-02T21:00:00'),

-- 01:00 МК (3 јули) | 19:00 ET | BMO Field, Toronto
(21, 22, 'Round of 32', 'BMO Field, Toronto', '2026-07-03T01:00:00'),

-- 05:00 МК (3 јули) | 23:00 ET | BC Place, Vancouver
(25, 26, 'Round of 32', 'BC Place, Vancouver', '2026-07-03T05:00:00'),

-- =====================
-- 3 ЈУЛИ (Петок)
-- =====================

-- 20:00 МК | 14:00 ET | AT&T Stadium, Arlington
(32, 31, 'Round of 32', 'AT&T Stadium, Arlington', '2026-07-03T20:00:00'),

-- 00:00 МК (4 јули) | 18:00 ET | Hard Rock Stadium, Miami
(27, 28, 'Round of 32', 'Hard Rock Stadium, Miami', '2026-07-04T00:00:00'),

-- 03:30 МК (4 јули) | 21:30 ET | Arrowhead Stadium, Kansas City
(29, 30, 'Round of 32', 'Arrowhead Stadium, Kansas City', '2026-07-04T03:30:00');

-- ============================================================
-- ПРЕГЛЕД НА НАТПРЕВАРИТЕ (МК ВРЕМЕ):
-- 28.06 21:00 | South Africa (1) vs Canada (2)
-- 29.06 19:00 | Brazil (3) vs Japan (4)
-- 29.06 22:30 | Germany (5) vs Paraguay (6)
-- 30.06 03:00 | Netherlands (7) vs Morocco (8)
-- 30.06 19:00 | Ivory Coast (11) vs Norway (12)
-- 30.06 23:00 | France (9) vs Sweden (10)
-- 01.07 03:00 | Mexico (13) vs Ecuador (14)
-- 01.07 18:00 | England (15) vs DR Congo (16)
-- 01.07 22:00 | Belgium (19) vs Senegal (20)
-- 02.07 02:00 | USA (17) vs Bosnia & Herzegovina (18)
-- 02.07 21:00 | Spain (23) vs Austria (24)
-- 03.07 01:00 | Portugal (21) vs Croatia (22)
-- 03.07 05:00 | Switzerland (25) vs Algeria (26)
-- 03.07 20:00 | Australia (32) vs Egypt (31)
-- 04.07 00:00 | Argentina (27) vs Cape Verde (28)
-- 04.07 03:30 | Colombia (29) vs Ghana (30)
-- ============================================================