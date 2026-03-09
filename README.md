# Cognitive Performance Analysis Using Linear Regression


## Overview

This project analyzes factors that may influence cognitive performance using statistical methods and linear regression modeling in R.

The analysis examines behavioral and physiological variables such as sleep duration, stress level, caffeine intake, screen time, and physical activity in order to understand how they relate to cognitive performance.

The project was conducted as part of a course in **Linear Regression Models** and is divided into two main stages:

1. Exploratory Data Analysis  
2. Regression Modeling and Diagnostics  

The goal of the project is to explain the variability in **Cognitive_Score**, which represents the overall cognitive performance of each participant.

---

# Dataset Description

The dataset contains behavioral and physiological measurements for a large group of participants.

Each observation includes variables related to lifestyle, habits, and performance metrics.

### Dependent Variable

**Cognitive_Score**

Represents the overall cognitive performance score of the participant on a scale from 0–100.

Higher values indicate better cognitive performance.

### Explanatory Variables

| Variable | Description |
|--------|-------------|
| Age | Age of participant |
| Gender | Participant gender |
| Sleep_Duration | Average nightly sleep duration |
| Stress_Level | Self-reported stress level (1–10) |
| Diet_Type | Type of diet |
| Daily_Screen_Time | Average screen time per day |
| Exercise_Frequency | Weekly exercise frequency |
| Caffeine_Intake | Daily caffeine intake (mg) |
| Reaction_Time | Reaction time measurement |
| Memory_Test_Score | Memory performance test score |

The objective is to determine which of these variables contribute significantly to explaining cognitive performance.

---

# Project Structure


project
│
├── data
│ └── sample_data.xlsx
│
├── scripts
│ ├── R_part1.R
│ └── R_part2.R
│
├── reports
│ ├── project_part1.docx
│ └── project_part2.docx
│
├── screenshots
│ ├── part1
│ │ ├── histogram_screen.jpg
│ │ ├── cdf_screen.jpg
│ │ ├── reaction_vs_sleep.jpg
│ │ ├── reaction_vs_caffeine.jpg
│ │ ├── screen_vs_sleep_by_stress.jpg
│ │ ├── cognitive_across_sleep.jpg
│ │ └── cognitive_vs_screen_by_color.jpg
│ │
│ └── part2
│ ├── final_model.jpg
│ ├── interaction_memory_vs_stress.jpg
│ ├── res_vs_fitted.jpg
│ ├── qq_plot.jpg
│ └── box_cox.jpg
│
└── README.md


---

# Part 1 — Exploratory Data Analysis

The first stage of the project focuses on understanding the structure and behavior of the dataset through descriptive statistics and visual analysis.

Several statistical measures were calculated for the continuous variables, including:

- Mean  
- Median  
- Standard deviation  
- Interquartile range  
- Skewness  

These measures help characterize the distribution of the variables and identify potential irregularities in the data.

---

## Distribution of Screen Time

![Screen Time Histogram](screenshots/part1/histogram_screen.jpg)

The histogram shows the distribution of daily screen time across participants.

Screen time values are spread across the entire observed range, indicating large variation in digital device usage among individuals.

---

## Cumulative Distribution of Screen Time

![Screen Time CDF](screenshots/part1/cdf_screen.jpg)

The cumulative distribution function illustrates how observations accumulate across the screen time range.  
The gradual increase suggests that screen time values are distributed relatively evenly throughout the interval.

---

## Sleep Duration and Reaction Time

![Sleep Reaction](screenshots/part1/reaction_vs_sleep.jpg)

This figure illustrates the relationship between sleep duration and reaction time.

A mild negative relationship can be observed, suggesting that individuals who sleep longer tend to exhibit slightly faster reaction times.

---

## Reaction Time and Caffeine Intake

![Caffeine Reaction](screenshots/part1/reaction_vs_caffeine.jpg)

The relationship between caffeine intake and reaction time appears weak and inconsistent.

---

## Behavioral Patterns: Sleep, Screen Time and Stress

![Sleep Screen Stress](screenshots/part1/screen_vs_sleep_by_stress.jpg)

This visualization explores the relationship between sleep duration and daily screen time across different stress levels.

Participants with higher stress levels appear more frequently in regions associated with higher screen time and slightly lower sleep duration.

---

## Cognitive Performance by Sleep Duration

![Cognitive Sleep](screenshots/part1/cognitive_across_sleep.jpg)

The violin plot compares cognitive score distributions across sleep duration groups.

Participants with moderate sleep durations show slightly higher median cognitive scores.

---

## Screen Time and Cognitive Score

![Screen Cognitive](screenshots/part1/cognitive_vs_screen_by_color.jpg)

The two-dimensional density contour plot presents the joint distribution of daily screen time and cognitive performance.

---

# Part 2 — Regression Modeling

The second stage of the project focuses on constructing a multivariate linear regression model to explain the variation in cognitive performance.

Variable screening was conducted using **Pearson correlation tests** for continuous variables and **ANOVA tests** for categorical variables.

For example, Age showed almost no correlation with Cognitive_Score and was therefore excluded from the final model. :contentReference[oaicite:0]{index=0}

---

## Final Regression Model

![Regression Model](screenshots/part2/final_model.jpg)

The final model includes the following predictors:

- Sleep duration  
- Stress level  
- Daily screen time  
- Exercise frequency  
- Reaction time  
- Memory test score  
- Diet type  
- Caffeine intake (including a quadratic term)

An interaction term between **Memory_Test_Score and Stress_Level** was also included in the model.

---

## Interaction Effect: Memory Score × Stress Level

![Memory Stress Interaction](screenshots/part2/interaction_memory_vs_stress.jpg)

The interaction analysis shows that the relationship between memory performance and cognitive score varies across stress levels.

---

# Model Diagnostics

Several diagnostic tools were used to evaluate the assumptions of the regression model.

---

## Residuals vs Fitted Values

![Residuals vs Fitted](screenshots/part2/res_vs_fitted.jpg)

Residuals appear centered around zero, suggesting the model captures most of the systematic variation in the data.

---

## Q-Q Plot of Residuals

![QQ Plot](screenshots/part2/qq_plot.jpg)

The Q-Q plot compares standardized residuals with the theoretical normal distribution.

---

# Model Improvement

A **Box-Cox transformation analysis** was performed to determine whether transforming the dependent variable would improve model fit.

![Box Cox](screenshots/part2/box_cox.jpg)

The estimated transformation parameter was:

λ ≈ 1

This indicates that no transformation of the dependent variable was required.

---

# Technologies Used

- R  
- Linear Regression Modeling  
- Exploratory Data Analysis  
- Statistical Diagnostics  
- Data Visualization  

---

# Authors

Group Project — Linear Regression Models

- Yoav Nesher  
- Roi Laniado

---

# Notes

This project was developed as part of coursework in statistical modeling and regression analysis.
