# Cognitive Performance Analysis Using Linear Regression

## Overview

This project analyzes factors that may influence cognitive performance using statistical methods and linear regression modeling in R.

The analysis examines behavioral and physiological variables such as sleep duration, stress level, caffeine intake, screen time, and physical activity in order to understand how they relate to cognitive performance.

The project was conducted as part of a course in **Linear Regression Models** and is divided into two main stages:

1. Exploratory Data Analysis  
2. Regression Modeling and Diagnostics  

The goal of the project is to explain the variability in **Cognitive_Score**, which represents the overall cognitive performance of each participant.

---

# Key Findings

A multivariate linear regression analysis was conducted to explain and predict **Cognitive_Score** using behavioral and physiological variables.

The analysis was implemented entirely in **R**, following the statistical methodology taught in the course, without modifying the original dataset.

During the preprocessing stage, univariate relationships between the dependent variable and candidate predictors were examined. Pearson correlation tests were used for continuous variables and one-way ANOVA tests for categorical variables.

Based on these results:

- **Age** was removed due to negligible linear correlation with Cognitive_Score.
- **Gender** was removed because category aggregation did not improve the model.

For the categorical variable **Diet_Type**, the categories *Vegetarian* and *Vegan* were merged into a new category **PlantBased**, creating a dummy variable **Diet_2** with *Non-Vegetarian* as the reference group.

Several theoretically motivated interaction terms were evaluated. Among them, the interaction **Memory_Test_Score × Stress_Level** was found to be statistically significant and improved model fit. Other interactions such as:

- Daily_Screen_Time × Stress_Level  
- Daily_Screen_Time × Diet_2  

were not significant and were therefore excluded.

Variable selection was performed using both **Forward Selection** and **Backward Elimination** according to the **AIC criterion**. Both procedures converged to the same model, reinforcing the stability of the selected specification.

The final model includes the variables:

- Sleep_Duration  
- Stress_Level  
- Daily_Screen_Time  
- Exercise_Frequency  
- Reaction_Time  
- Memory_Test_Score  
- Diet_2  
- Caffeine_Intake  

as well as the interaction:

- **Memory_Test_Score × Stress_Level**

Further model improvement analysis revealed evidence of **non-linearity for Caffeine_Intake**, and therefore a **second-degree polynomial term** was introduced.

Model assumptions were evaluated using:

- Residual vs Fitted plots
- Q-Q plots
- Shapiro-Wilk test
- Kolmogorov-Smirnov test
- Chow test for structural stability

Although the residual normality tests indicated deviations, these were interpreted in light of the large sample size, where even small deviations may lead to significant results.

A **Box-Cox transformation analysis** was performed for the dependent variable. The estimated parameter λ was very close to 1, indicating that no transformation of **Cognitive_Score** was necessary.

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

---

# Part 1 — Exploratory Data Analysis

The first stage focuses on understanding the structure and behavior of the dataset through descriptive statistics and visual analysis.

Key descriptive measures were computed, including:

- Mean
- Median
- Standard deviation
- Interquartile range
- Skewness

These statistics help characterize the distribution of variables and identify potential irregularities.

---

## Distribution of Screen Time

<img src="screenshots/part1/histogram_screen.jpg" width="560">

The histogram presents the distribution of daily screen time across participants.  
The spread of values indicates considerable variability in digital device usage between individuals.

---

## Cumulative Distribution of Screen Time

<img src="screenshots/part1/cdf_screen.jpg" width="560">

The cumulative distribution function illustrates how screen-time observations accumulate across the range of values.  
The smooth increase suggests that screen time is relatively evenly distributed across participants.

---

## Sleep Duration and Reaction Time

<img src="screenshots/part1/reaction_vs_sleep.jpg" width="560">

This scatter plot explores the relationship between sleep duration and reaction time.  
A mild negative trend can be observed, suggesting that longer sleep duration may be associated with slightly faster reaction times.

---

## Reaction Time and Caffeine Intake

<img src="screenshots/part1/reaction_vs_caffeine.jpg" width="560">

This plot examines the relationship between caffeine intake and reaction time.  
The pattern appears relatively weak, indicating that caffeine intake alone may not strongly explain reaction time variability.

---

## Behavioral Patterns: Sleep, Screen Time and Stress

<img src="screenshots/part1/screen_vs_sleep_by_stress.jpg" width="560">

This visualization combines sleep duration and daily screen time while differentiating participants by stress level.  
Higher stress levels appear more frequently in regions associated with higher screen time and slightly reduced sleep duration.

---

## Cognitive Performance by Sleep Duration

<img src="screenshots/part1/cognitive_across_sleep.jpg" width="560">

The violin plot compares the distribution of cognitive scores across sleep duration groups.  
Participants with moderate sleep durations appear to have slightly higher median cognitive scores.

---

## Screen Time and Cognitive Score

<img src="screenshots/part1/cognitive_vs_screen_by_color.jpg" width="560">

This density visualization shows the joint distribution of screen time and cognitive performance.  
While no strong linear relationship is visible, moderate screen time levels appear frequently in mid-range cognitive scores.

---

# Part 2 — Regression Modeling

The second stage focuses on constructing a multivariate linear regression model to explain the variation in **Cognitive_Score**.

Variable selection and model construction followed a structured statistical procedure including correlation analysis, ANOVA tests, and automated model selection using the **AIC criterion**.

---

## Final Regression Model

<img src="screenshots/part2/final_model.jpg" width="560">

This equation represents the final multivariate regression model selected for explaining cognitive performance.  
It incorporates the significant behavioral variables and interaction effects identified during model selection.

---

## Interaction Effect: Memory Score × Stress Level

<img src="screenshots/part2/interaction_memory_vs_stress.jpg" width="560">

The figure illustrates how the relationship between memory test performance and cognitive score varies across stress levels.  
The differing slopes indicate that stress moderates the influence of memory ability on overall cognitive performance.

---

# Model Diagnostics

## Residuals vs Fitted

<img src="screenshots/part2/res_vs_fitted.jpg" width="560">

This diagnostic plot examines whether residuals are randomly distributed around zero, which is expected when the linear model captures most systematic variation in the data.

A noticeable pattern of large residuals appears at the extremes of the fitted values. This occurs because the dependent variable **Cognitive_Score** is naturally bounded between **0 and 100**, while a linear regression model produces **unbounded predictions**.  

When combinations of explanatory variables lead the model to predict values outside this range (below 0 or above 100), the predicted value is far from the observed score, resulting in larger residuals.

This phenomenon reflects a structural limitation of linear regression when modeling bounded outcomes rather than a failure of the model specification.

---

## Q-Q Plot of Residuals

<img src="screenshots/part2/qq_plot.jpg" width="560">

The Q-Q plot compares standardized residuals with a theoretical normal distribution.  
While many residuals follow the expected linear pattern, deviations are visible in the tails.

These deviations are partially explained by the bounded nature of **Cognitive_Score**.  
Because the model may occasionally produce predictions outside the feasible range, the resulting large residuals contribute to heavier tails in the residual distribution.

---

# Model Improvement

A Box-Cox transformation analysis was conducted in order to determine whether transforming the dependent variable could improve the regression model.

<img src="screenshots/part2/box_cox.jpg" width="560">

The estimated parameter:

λ ≈ 1

This indicates that the original scale of **Cognitive_Score** already provides an appropriate functional form for the regression model.

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

---

# Project Structure

```text
project
├── data
│   └── sample_data.xlsx
├── scripts
│   ├── R_part1.R
│   └── R_part2.R
├── reports
│   ├── project_part1.docx
│   └── project_part2.docx
├── screenshots
│   ├── part1
│   │   ├── histogram_screen.jpg
│   │   ├── cdf_screen.jpg
│   │   ├── reaction_vs_sleep.jpg
│   │   ├── reaction_vs_caffeine.jpg
│   │   ├── screen_vs_sleep_by_stress.jpg
│   │   ├── cognitive_across_sleep.jpg
│   │   └── cognitive_vs_screen_by_color.jpg
│   └── part2
│       ├── final_model.jpg
│       ├── interaction_memory_vs_stress.jpg
│       ├── res_vs_fitted.jpg
│       ├── qq_plot.jpg
│       └── box_cox.jpg
└── README.md
