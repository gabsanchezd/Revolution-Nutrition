 **Repository Structure**
| Folder               | Contents                                                 |
| -------------------- | ---------------------------------------------------------|
| datasets             | contains data of gold, silver, and bronze layer          |
| docs                 | contains catalog for dimension and fact tables           | 
| scripts              | contains DDL scripts for bronze, silver, and gold layer  | 
| Visualization        | contains exported charts and dashboard images            | 

**Revolution-Nutrition Analytics**
- **Ingestion & ETL**: Load multi-source CSVs, standardize dates/currency, create keys, and clean/null-normalize with light dedupe and lookups.
- **Data Quality**: Monitor unknown source/campaign, null dates, FK mismatches, and outliers; quarantine >5% issues and block loads when unknowns spike.
- **Core KPIs & Measures**: Revenue, Orders, GM/GM%, AOV, ROAS, Blended CAC, CVR, CTR/CPC/CPM, CLV @6/12m, Cohort GM Cum.
- **Power BI Pages**: Executive, CAC, Campaign Funnel, Product, Cohorts/Payback, and Data Quality—each with additive bases, slicers, and targeted diagnostics.
- **Governance & Cadence**: 30/60/90 plan (payback-aware budgeting, LP/PDP and checkout fixes, promo guardrails) with conservative Day-90 improvements in CAC, CVR, GM%, and payback.

## Table of Contents
- [Project Background](#project-background)
- [Executive Overview](#executive-overview)
  - [Campaign Level Funnel](#campaign-level-funnel)
  - [CAC](#CAC)
  - [CLV/Cohorts/Payback](#CLVCohortsPayback)
  - [Channel & Store](#Product)
- [Recommendations](#recommendations)
- [Forecast (90 days)](#forecast-90-days)
- [Data Model (Star Schema)](#data-model-star-schema)  
- [Assumptions and Caveats](#assumptions-and-caveats)

---

## Project Background
Revolution Nutrition is a Canada-based sports-nutrition brand selling whey proteins, isolates, BCAA/EAA, pre-workouts, and collagen through its online store. The main business and marketing challenges are inconsistent acquisition efficiency, tracking and attribution gaps, friction on product pages and checkout, heavy dependence on paid search, margin pressure from discounts, and slow early repeat from new customers. The funnel is wide at the top, yet many sessions do not turn into orders. Newer cohorts bring in value more slowly than those from spring and summer. Margin is strong on a few hero products but weaker in other lines when discounts rise. Google performs well, Meta underperforms at its current audiences. Overall acquisition cost is okay, but efficiency changes from month to month.

---

## Executive Overview
![Executive Overview](https://github.com/gabsanchezd/Revolution-Nutrition/blob/main/visuals/Executive%20Overview.png?raw=true "Executive Overview title")

Net revenue is about $2.27 million with gross margin near $0.98 million and both are up versus last month and last year, while spend is modest at about 12 thousand and new customers are growing, giving a low CAC around 0.63 and healthy efficiency. Revenue is led by paid search and by search campaigns for BCAA and Whey Isolate, and the subcategory mix is dominated by whey lines with EAA also strong. Month by month, spend and revenue track closely with no major drops, suggesting stable scaling.

### Campaign Level Funnel

![CampaignLevelFunnel](https://github.com/gabsanchezd/Revolution-Nutrition/blob/main/visuals/CampaignLevelFunnel.png?raw=true "CampaignLevelFunnel")
- Impressions are high but too few sessions turn into orders, and clicks appear lower than orders, which hints at tracking or attribution issues.
- Google Ads shows the best conversion and higher average order value, TikTok is middle of the pack, and Meta underperforms.
- Search campaigns for BCAA and Whey Isolate drive net revenue. Sessions stay steady through the year while orders dip later, suggesting conversion erosion.


### CAC
![CAC](https://github.com/gabsanchezd/Revolution-Nutrition/blob/main/visuals/CAC.png?raw=true "CAC")
- Spend remains steady with a late-year dip as shown in Spend by Month, while new-customer counts swing more in New Customers by Month, signaling uneven efficiency.
- CAC by Channel Group shows Referral and Email as the cheapest sources and Affiliate as the highest, suggesting an attribution check.
- CAC, New Customers, and Spend by Platform highlights Google Ads bringing the most new customers at lower CAC, TikTok in the middle, and Meta with the highest CAC despite sizable spend.


### CLV/Cohorts/Payback

![CLVCohortsPayback](https://github.com/gabsanchezd/Revolution-Nutrition/blob/main/visuals/CLVCohortsPayback.png?raw=true "CLVCohortsPayback")
- CLV rises from 6 months to 12 months as expected, but only a few cohorts deliver standout value, with August showing the strongest 12-month CLV while several late-year cohorts lag. 
- Cohort Revenue Cum peaks in May then falls sharply, implying weaker monetization from newer cohorts rather than a volume issue.
- Cohort Size stays fairly steady with a dip in late summer and a rebound into December, so the recent slowdown is quality not quantity.


### Product

![Product](https://github.com/gabsanchezd/Revolution-Nutrition/blob/main/visuals/Product.png?raw=true "Product")
- Whey Protein drives the bulk of revenue with Aminos next, and margin leaders are High Whey and BCAA Splash.
- Health and Wellness shows higher COGS pressure, while discounts are most visible outside Protein, so tighten promo rules where margin is thin.
- Vanilla is the dominant flavor with clear volume concentration, suggesting room to scale supply while pruning or reworking weaker flavors.


## Recommendations

  ### 0–30 days: Quick wins
  - Close gaps so clicks match sessions within a small margin and campaign keys populate above 98 percent
  - Shift 15 to 25 percent of Meta spend to best Google search campaigns and to referral and email
  - Pause or cap the worst 10 percent of campaigns by CAC
  - Ship intent matched landing pages for top five campaigns
  - Update PDPs with benefits, reviews, delivery promise, and bundles
  - Surface total cost earlier and enable one tap wallets on mobile
  - Publish discount guardrails by category and start a hero SKU bundle

  ### 31–60 days: Scale what works, Fix structural frictions

- Expand budget into campaigns that hit payback within three months; continue to cap those that do not
- Rebuild Meta with new audiences and fresh creative every two weeks
- Remove one step on mobile checkout and fix top error codes
- Scale bundles and add one new bundle around a high GM SKU
- Review underperforming flavors and trim or rework the weakest
- Add first order cross sell, day 14 and day 30 replenishment nudges, and a two pack offer

  ### 61–90 days: Scale what works, Fix structural frictions

- Lock naming conventions and monitoring
- Scale proven campaigns and platforms; re enter or expand Meta only where CAC is within 10 percent of target
- Launch a small test budget on one new channel or audience if payback model allows
- Convert the best performing LP and PDP variants into standards and roll them to more campaigns
- Ship the next mobile checkout improvements based on drop off analysis
- Launch win back for 45 to 90 day inactive customers and a VIP tier for high CLV cohorts

### Forecast
- Sessions to Orders conversion rate: +3%-4% (from 32k orders)
- Gross Margin %: +2.0 → 2.8% (from $1M)
- Blended CAC – 10.0 - 13.0%
- New customers +7.0 → 9.8%
- Months to payback for new cohorts - 0.5 - 0.7%
- Discount share of revenue - 1.3 - 1.8%

## Data Model (Star Schema)

### **Dimension Table** and **Fact Table**





## Tech Stack

| Layer                        | Tools and Libraries                         |
| ---------------------------- | --------------------------------------------|
| Data Extraction              | Google Ads & GA4 / Shopify / SAP / Meta     |
| Cleaning                     | MySQL / Python (Panda, Numpy)               | 
| Visualization                | PowerBI                                     | 


## Assumptions and Caveats

- **Duplicates & typos**: Dupes and misspellings (e.g., campaign names, flavors).
- **Tracking drift**: Some periods intentionally include UTM/pixel gaps.
- **Null handling**: Minimal imputation in unknown campaign/source buckets, 19000101 sentinel for missing dates to keep rows analyzable.
- **Subscription/retention**: Repeat behavior is present but not a formal subscription program; CLV is non-contractual, so churn is implicit and noisier.
- **Refund timing**: Refunds can occur after the order month; GM and payback for recent cohorts may improve then regress as refunds land.
