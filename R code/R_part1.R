
# 3.1This script performs data processing and visualization as part of the human cognitive performance analysis project.
library(dplyr)
library(ggplot2)


avg_reaction <- data %>%
  mutate(Caffeine_Group = cut(Caffeine_Intake,
                              breaks = seq(0, 500, by = 50),
                              include.lowest = TRUE)) %>%
  group_by(Caffeine_Group) %>%
  summarise(Mean_Reaction = mean(Reaction_Time, na.rm = TRUE),
            Mid_Caffeine = mean(Caffeine_Intake, na.rm = TRUE))


ggplot(avg_reaction, aes(x = Mid_Caffeine, y = Mean_Reaction)) +
  geom_line(color = "darkred", linewidth = 1.2) +
  geom_point(size = 2.5, color = "orange") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Average Reaction Time by Caffeine Intake (Binned)",
    x = "Caffeine Intake (mg/day)",
    y = "Average Reaction Time (ms)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.grid.minor = element_blank()
  )



# 3.2This script analyzes how average daily screen time varies across different caffeine intake levels.

library(dplyr)
library(ggplot2)


avg_screen <- data %>%
  mutate(Caffeine_Group = cut(Caffeine_Intake,
                              breaks = seq(0, 500, by = 50),
                              include.lowest = TRUE)) %>%
  group_by(Caffeine_Group) %>%
  summarise(Mean_Screen = mean(Daily_Screen_Time, na.rm = TRUE),
            Mid_Caffeine = mean(Caffeine_Intake, na.rm = TRUE))


ggplot(avg_screen, aes(x = Mid_Caffeine, y = Mean_Screen)) +
  geom_line(color = "darkblue", linewidth = 1.2) +
  geom_point(size = 2.5, color = "orange") +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(
    title = "Average Screen Time by Caffeine Intake",
    x = "Caffeine Intake (mg/day)",
    y = "Average Daily Screen Time (Hours)"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    panel.grid.minor = element_blank()
  )

# 3.3This script loads the dataset, draws a 30% random sample, computes average sleep duration by age, and plots a regression line.

library(readxl)

df <- read_excel("C:\Users\yoavn\OneDrive\Documents\הנדסה תעשייה וניהול\שנה_ג\סמס א\רגרסיה\Linear Regression Project\data\sample_data.xlsx")

set.seed(123)
sample_index <- sample(1:nrow(df), size = 0.30 * nrow(df))
df_small <- df[sample_index, ]

sleep_age_avg <- aggregate(Sleep_Duration ~ Age,
                           data = df_small,
                           FUN = mean)

plot(sleep_age_avg$Age,
     sleep_age_avg$Sleep_Duration,
     xlab = "Age",
     ylab = "Mean Sleep Duration (hours)",
     main = "Mean Sleep Duration vs Age (30% Sample)",
     pch = 16,
     col = "pink")

model_sleep_age <- lm(Sleep_Duration ~ Age, data = sleep_age_avg)

abline(model_sleep_age, col = "red", lwd = 3)

# 3.4This script analyzes how average reaction time changes with sleep duration using a 30% random sample of the dataset.

library(readxl)
set.seed(123)
sample_index <- sample(1:nrow(df), size = 0.30 * nrow(df))
df_small <- df[sample_index, ]

sleep_avg <- aggregate(Reaction_Time ~ Sleep_Duration,
                       data = df_small,
                       FUN = mean)

plot(sleep_avg$Sleep_Duration,
     sleep_avg$Reaction_Time,
     xlab = "Sleep Duration (hours)",
     ylab = "Mean Reaction Time",
     main = "Mean Reaction Time vs Sleep Duration (30% Sample)",
     pch = 16,
     col = "pink")

model_avg <- lm(Reaction_Time ~ Sleep_Duration, data = sleep_avg)

abline(model_avg, col = "red", lwd = 3)

# 3.5 This script groups participants into 5-year age intervals and analyzes how average daily screen time varies across age groups.
install.packages("dplyr")
install.packages("ggplot2")

# טעינת הספריות
library(dplyr)
library(ggplot2)

# יצירת קבוצות גיל של 5 שנים
data$Age_Group <- cut(
  data$Age,
  breaks = seq(15, 60, by = 5),
  include.lowest = TRUE,
  right = FALSE,
  labels = c("15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59")
)

# חישוב ממוצע זמן מסך בכל קבוצת גיל
avg_screen_time <- data %>%
  group_by(Age_Group) %>%
  summarise(Mean_Screen_Time = mean(Daily_Screen_Time, na.rm = TRUE))

# גרף קווי של ממוצעים
ggplot(avg_screen_time, aes(x = Age_Group, y = Mean_Screen_Time, group = 1)) +
  geom_line(color = "orange", linewidth = 1.2) +
  geom_point(size = 3, color = "darkgreen") +
  labs(
    title = "Average Daily Screen Time by Age Group",
    x = "Age Group (Years)",
    y = "Average Daily Screen Time (Hours)"
  ) +
  theme_minimal()




# 4.Gender Cognitive Score Summary
install.packages("moments")
library(moments)
gender_analysis <- data %>%
group_by(Gender) %>%
summarise(
mean = mean(Cognitive_Score, na.rm = TRUE),
median = median(Cognitive_Score, na.rm = TRUE),
sd = sd(Cognitive_Score, na.rm = TRUE),
IQR = IQR(Cognitive_Score, na.rm = TRUE),
skewness = skewness(Cognitive_Score, na.rm = TRUE),
n = n()
)
gender_analysis



# Descriptive Statistics for Continuous Variables
library(dplyr)
library(moments)

# Select only the continuous variables
numeric_vars <- data %>%
  select(Age, Sleep_Duration, Daily_Screen_Time, Caffeine_Intake, Reaction_Time)

# Calculate descriptive statistics
desc_stats <- data.frame(
  Variable = colnames(numeric_vars),
  Mean = sapply(numeric_vars, mean, na.rm = TRUE),
  Median = sapply(numeric_vars, median, na.rm = TRUE),
  SD = sapply(numeric_vars, sd, na.rm = TRUE),
  IQR = sapply(numeric_vars, IQR, na.rm = TRUE),
  Skewness = sapply(numeric_vars, skewness, na.rm = TRUE)
)

# Print the clean result
print(desc_stats, row.names = FALSE)













# Descriptive Boxplot with Mean, SD, SE and Summary Table


if (!requireNamespace("dplyr", quietly=TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly=TRUE)) install.packages("ggplot2")
if (!requireNamespace("moments", quietly=TRUE)) install.packages("moments")

library(dplyr)
library(ggplot2)
library(moments)

plot_descriptive_by_cat <- function(df, y_var, cat_var, title = NULL, y_lab = NULL) {
  y <- rlang::ensym(y_var)
  g <- rlang::ensym(cat_var)

  #4. summary per category
  summ <- df %>%
    group_by(!!g) %>%
    summarise(
      n       = sum(!is.na(!!y)),
      mean    = mean(!!y, na.rm = TRUE),
      median  = median(!!y, na.rm = TRUE),
      sd      = sd(!!y, na.rm = TRUE),
      se      = sd / sqrt(n),
      q1      = quantile(!!y, 0.25, na.rm = TRUE),
      q3      = quantile(!!y, 0.75, na.rm = TRUE),
      IQR     = IQR(!!y, na.rm = TRUE),
      skew    = skewness(!!y, na.rm = TRUE),
      .groups = "drop"
    )

  print(summ)

  y_range <- range(dplyr::pull(df, !!y), na.rm = TRUE)
  y_span  <- diff(y_range)

  ggplot(df, aes(x = !!g, y = !!y, fill = !!g)) +
    # boxplot (Q1–Q3 + median)
    geom_boxplot(alpha = 0.35, outlier.alpha = 0.15, width = 0.55, color = "black") +
    # mean point (◆)
    geom_point(
      data = summ,
      inherit.aes = FALSE,
      aes(x = !!g, y = mean),
      shape = 23, size = 3.5, fill = "black", color = "white"
    ) +
    # error bars: ±SD
    geom_errorbar(
      data = summ,
      inherit.aes = FALSE,
      aes(x = !!g, ymin = mean - sd, ymax = mean + sd, color = "±SD"),
      width = 0.18, linewidth = 0.7, alpha = 0.9
    ) +
    # error bars: ±SE
    geom_errorbar(
      data = summ,
      inherit.aes = FALSE,
      aes(x = !!g, ymin = mean - se, ymax = mean + se, color = "±SE"),
      width = 0.36, linewidth = 1.1, alpha = 0.9
    ) +
    # labels over mean
    geom_text(
      data = summ,
      inherit.aes = FALSE,
      aes(x = !!g, y = mean, label = sprintf("%.1f", mean)),
      vjust = -1.0, size = 4
    ) +
    # n and skew in the top area
    geom_text(
      data = summ,
      inherit.aes = FALSE,
      aes(x = !!g,
          y = y_range[2] - 0.03 * y_span,
          label = paste0("n=", n, "\nskew=", sprintf("%.2f", skew))),
      size = 3.3, lineheight = 1.0
    ) +
    scale_color_manual(name = "Error Bars",
                       values = c("±SD" = "black", "±SE" = "firebrick")) +
    labs(
      title = ifelse(is.null(title),
                     paste0("Descriptive Statistics of ",
                            rlang::as_name(y), " by ", rlang::as_name(g)),
                     title),
      x     = rlang::as_name(g),
      y     = ifelse(is.null(y_lab), rlang::as_name(y), y_lab)
    ) +
    theme_minimal(base_size = 13) +
    theme(legend.position = "top")
}

# דוגמה להרצה:
plot_descriptive_by_cat(
  df = data,
  y_var = Cognitive_Score,
  cat_var = Gender,
  title = "Cognitive Score by Gender: Boxplot + Mean + ±SD/±SE",
  y_lab = "Cognitive Score"
)






# 5.Outlier Detection and Boxplots for Multiple Variables

boxplot(df$Age,
        main = "Boxplot of Age - Checking for Outliers",
        ylab = "Age",
        col = "pink",
        border = "black")






boxplot(df$Daily_Screen_Time,
        main = "Boxplot of Daily Screen Time - Checking for Outliers",
        ylab = "Daily Screen Time",
        col = "lightgreen",




        border = "black")

library(dplyr)
library(ggplot2)

x <- data$Sleep_Duration

q1  <- quantile(x, 0.25, na.rm = TRUE)
q3  <- quantile(x, 0.75, na.rm = TRUE)
iqr <- IQR(x, na.rm = TRUE)

lower_mild    <- q1 - 1.5 * iqr
upper_mild    <- q3 + 1.5 * iqr
lower_extreme <- q1 - 3 * iqr
upper_extreme <- q3 + 3 * iqr

sleep_outliers <- data %>%
  mutate(
    mild_outlier    = Sleep_Duration < lower_mild | Sleep_Duration > upper_mild,
    extreme_outlier = Sleep_Duration < lower_extreme | Sleep_Duration > upper_extreme
  )

mild_n    <- sum(sleep_outliers$mild_outlier, na.rm = TRUE)
extreme_n <- sum(sleep_outliers$extreme_outlier, na.rm = TRUE)

cat("Mild outliers:", mild_n, "\n")
cat("Extreme outliers:", extreme_n, "\n")

ggplot(data, aes(y = Sleep_Duration)) +
  geom_boxplot(fill = "#C9DFF2", color = "black",
               outlier.colour = "red", outlier.size = 2) +
  labs(title = "Sleep Duration – Boxplot", y = "Hours of Sleep") +
  theme_minimal(base_size = 14)






boxplot(df$Caffeine_Intake,
        main = "Boxplot of Caffeine Intake - Checking for Outliers",
        ylab = "Caffeine Intake (mg)",
        col = "saddlebrown",
        border = "black")



# 6.Histograms, Density Plots, and CDFs for Selected Variables

par(mfrow = c(3, 3))  # 3 שורות, 3 עמודות

vars <- c("Caffeine_Intake", "Daily_Screen_Time", "Sleep_Duration")

for (v in vars) {
  
  # Histogram
  hist(df[[v]],
       main = paste("Histogram of", v),
       xlab = v,
       col = "lightblue",
       border = "white",
       probability = TRUE)
  
  # Density plot
  lines(density(df[[v]]), col = "red", lwd = 2)
  
  # CDF
  plot(ecdf(df[[v]]),
       main = paste("CDF of", v),
       xlab = v,
       ylab = "Cumulative Probability",
       col = "darkgreen",
       lwd = 2)
}



# 7.Scatter Plot of Screen Time vs Sleep Duration by Stress Level (2% Sample)

set.seed(123)
sample_index <- sample(1:nrow(df), size = 0.02 * nrow(df))
df_small <- df[sample_index, ]

df_small$Stress_Group <- cut(df_small$Stress_Level,
                             breaks = c(0, 3, 7, 10),
                             labels = c("Low", "Medium", "High"))

colors <- c("Low" = "#A6CEE3",
            "Medium" = "#B2DF8A",
            "High" = "#CAB2D6")

plot(df_small$Sleep_Duration,
     df_small$Daily_Screen_Time,
     col = colors[df_small$Stress_Group],
     pch = 16,
     xlab = "Sleep Duration (hours)",
     ylab = "Daily Screen Time (hours)",
     main = "Screen Time vs Sleep Duration by Stress Level (2% Sample)",
     cex = 1.2)

legend("topright",
       legend = names(colors),
       col = colors,
       pch = 16,
       cex = 1.1,
       bty = "o",
       bg = "white")




# 8Violin + Boxplot and 2D Density Plot for Cognitive Score Analysis
library(dplyr)
library(ggplot2)

data_sleep_groups <- data %>%
  mutate(Sleep_Group = cut(
    Sleep_Duration,
    breaks = c(4, 6, 7.5, 9, 10),
    labels = c("4–6", "6–7.5", "7.5–9", "9–10"),
    include.lowest = TRUE
  ))

ggplot(data_sleep_groups, aes(x = Sleep_Group, y = Cognitive_Score, fill = Sleep_Group)) +
  geom_violin(alpha = 0.6, color = "black") +
  geom_boxplot(width = 0.15, fill = "white", outlier.size = 1, alpha = 0.8) +
  labs(
    title = "Cognitive Score Across Sleep Duration Groups",
    x = "Sleep Duration (hours)",
    y = "Cognitive Score"
  ) +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none")


library(ggplot2)

ggplot(data, aes(x = Daily_Screen_Time, y = Cognitive_Score)) +
  geom_density_2d(color = "black", linewidth = 0.6) +
  geom_density_2d_filled(alpha = 0.6) +
  labs(
    title = "Cognitive Score vs Daily Screen Time (2D Density Contour)",
    x = "Daily Screen Time (hours)",
    y = "Cognitive Score"
  ) +
  theme_minimal(base_size = 14)











# 9Violin + Boxplot and 2D Density Plot for Cognitive Score Analysis

gender_freq <- table(df$Gender)
gender_rel  <- prop.table(gender_freq)

gender_table <- cbind(
  Frequency = gender_freq,
  Relative_Frequency = round(gender_rel, 4)
)

gender_table


diet_freq <- table(df$Diet_Type)
diet_rel  <- prop.table(diet_freq)

diet_table <- cbind(
  Frequency = diet_freq,
  Relative_Frequency = round(diet_rel, 4)
)

diet_table



# טבלת שכיחויות תזונה × סטרס
diet_stress_freq <- table(df$Diet_Type, df$Stress_Level)

# שכיחויות יחסיות
diet_stress_rel <- prop.table(diet_stress_freq, margin = 2)

# עיגול ל-4 ספרות
diet_stress_rel <- round(diet_stress_rel, 4)

# איחוד הטבלאות אחת מעל השנייה
diet_stress_table <- rbind(
  "Frequency" = diet_stress_freq,
  "Relative_Frequency" = diet_stress_rel
)

diet_stress_table

