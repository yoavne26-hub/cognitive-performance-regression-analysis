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


project/
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
│ │ ├── histogram_screen.png
│ │ ├── cdf_screen.png
│ │ ├── reaction_vs_sleep.png
│ │ ├── reaction_vs_caffeine.png
│ │ ├── screen_vs_sleep_by_stress.png
│ │ ├── cognitive_across_sleep.png
│ │ └── cognitive_vs_screen_by_color.png
│ │
│ └── part2
│ ├── final_model.png
│ ├── interaction_memory_vs_stress.png
│ ├── res_vs_fitted.png
│ ├── qq_plot.png
│ └── box_cox.png
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

These measures help characterize the distribution of the variables and identify potential irregularities in the data. :contentReference[oaicite:1]{index=1}

---

## Distribution of Screen Time

The following histogram illustrates the distribution of daily screen time among participants.

![Screen Time Histogram](screenshots/part1/histogram_screen.png)

The distribution appears relatively uniform across the observed range, indicating that screen usage varies considerably among individuals.

---

## Cumulative Distribution of Screen Time

![Screen Time CDF](screenshots/part1/cdf_screen.png)

The cumulative distribution shows a steady increase across the range of values, suggesting that observations are distributed relatively evenly throughout the interval.

---

## Sleep Duration and Reaction Time

![Sleep Reaction](screenshots/part1/reaction_vs_sleep.png)

This figure illustrates the relationship between sleep duration and reaction time.

A moderate negative trend can be observed, indicating that individuals who sleep longer tend to have slightly faster reaction times.

This relationship is consistent with the expectation that sufficient sleep improves alertness and cognitive processing.

---

## Reaction Time and Caffeine Intake

![Caffeine Reaction](screenshots/part1/reaction_vs_caffeine.png)

The relationship between caffeine consumption and reaction time shows a weak and inconsistent pattern.

Although moderate caffeine intake may improve alertness, higher consumption does not necessarily result in better reaction performance.

---

## Behavioral Patterns: Sleep, Screen Time and Stress

![Sleep Screen Stress](screenshots/part1/screen_vs_sleep_by_stress.png)

This visualization examines the relationship between sleep duration and screen time while distinguishing between different stress levels.

Participants reporting higher stress levels tend to appear more frequently in regions associated with higher screen time and slightly reduced sleep duration.

---

## Cognitive Performance by Sleep Duration

![Cognitive Sleep](screenshots/part1/cognitive_across_sleep.png)

This violin plot illustrates the distribution of cognitive scores across different sleep duration groups.

Participants with moderate sleep duration tend to have slightly higher median cognitive scores, although the distributions overlap considerably.

---

## Screen Time and Cognitive Score

![Screen Cognitive](screenshots/part1/cognitive_vs_screen_by_color.png)

The two-dimensional density plot shows the joint distribution of screen time and cognitive performance.

The visualization suggests that there is no strong linear relationship between these variables, although extremely high screen time may be associated with slightly lower cognitive scores.

---

# Part 2 — Regression Modeling

The second stage of the project focuses on constructing a multivariate linear regression model in order to explain the variation in cognitive performance.

---

## Variable Screening

Two statistical approaches were used to evaluate potential predictors:

- Pearson correlation tests for continuous variables
- ANOVA tests for categorical variables

Variables that showed very weak relationships with the dependent variable were removed from the model.

For example, **Age** showed almost no correlation with cognitive score and was excluded from further analysis.

---

## Final Regression Model

![Regression Model](screenshots/part2/final_model.png)

The final regression model includes the following predictors:

- Sleep duration
- Stress level
- Daily screen time
- Exercise frequency
- Reaction time
- Memory test score
- Caffeine intake
- Diet type

Additionally, a significant interaction effect was identified between memory test score and stress level.

---

## Interaction Effect: Memory Score × Stress Level

![Memory Stress Interaction](screenshots/part2/interaction_memory_vs_stress.png)

The interaction plot demonstrates that the relationship between memory performance and cognitive score varies across stress levels.

Participants with lower stress levels tend to show stronger positive relationships between memory score and overall cognitive performance.

---

# Model Diagnostics

Several diagnostic tools were used to evaluate the assumptions of the regression model.

---

## Residuals vs Fitted Values

![Residuals vs Fitted](screenshots/part2/res_vs_fitted.png)

The residual plot was used to assess linearity and homoscedasticity.

The distribution of residuals suggests that the model captures most of the systematic variation in the data.

---

## Q-Q Plot of Residuals

![QQ Plot](screenshots/part2/qq_plot.png)

The Q-Q plot compares the distribution of standardized residuals with the theoretical normal distribution.

Some deviations from normality are observed, which is common in large datasets.

---

# Model Improvement

To examine whether a transformation of the dependent variable could improve the model, a **Box-Cox transformation analysis** was performed.

![Box Cox](screenshots/part2/box_cox.png)

The estimated transformation parameter was approximately:

λ ≈ 1

This indicates that the original scale of the dependent variable is already appropriate and that no transformation is required.

---

# Technologies Used

- R
- Linear regression modeling
- Exploratory data analysis
- Statistical diagnostics
- Data visualization

---

# Authors

Group Project – Linear Regression Models

- Yoav Nesher  
- Project team members

---

# Notes

This project was developed for academic purposes as part of coursework in statistical modeling and regression analysis.
