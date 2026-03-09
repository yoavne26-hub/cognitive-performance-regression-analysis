############################################################
# Section 2.1 – Variable Screening
# Univariate analysis with respect to Cognitive_Score
############################################################

############################################################
# Table 1 – Pearson correlation for quantitative variables
############################################################

# List of quantitative explanatory variables
vars <- c(
  "Age",
  "Sleep_Duration",
  "Stress_Level",
  "Daily_Screen_Time",
  "Caffeine_Intake",
  "Reaction_Time",
  "Memory_Test_Score"
)

# Compute Pearson correlation with Cognitive_Score
cors <- sapply(vars, function(v) {
  cor(data[[v]], data$Cognitive_Score, use = "complete.obs")
})

# Create summary table
table_1 <- data.frame(
  Variable = vars,
  Correlation_with_Cognitive_Score = cors
)

print(table_1)

############################################################
# Table 2 – One-way ANOVA for categorical variables
############################################################

# Gender
anova_gender <- aov(Cognitive_Score ~ Gender, data = data)
summary(anova_gender)

# Exercise_Frequency
anova_exercise <- aov(Cognitive_Score ~ Exercise_Frequency, data = data)
summary(anova_exercise)

# Diet_Type
anova_diet <- aov(C_

2.2





# ============================================================
# Section 2.2 — Variable adjustments / recoding (NO data loading here)
# Assumption: a data.frame/tibble named `data` already exists in the environment.
# IMPORTANT: Do NOT name any object `df` (it conflicts with the built-in df() function).
# ============================================================

# ---------- Packages ----------
# (If you don't have them installed: install.packages(c("dplyr","tidyr","ggplot2")))
library(dplyr)
library(tidyr)
library(ggplot2)

# ============================================================
# (A) Categorical variables: counts table (Table 2.2.1)
# ============================================================

# Table 2.2.1: Counts by level for the categorical variables
cat_counts <- bind_rows(
  as.data.frame(table(data$Gender, useNA = "ifany")) %>%
    transmute(Variable = "Gender", Level = as.character(Var1), Count = Freq),
  as.data.frame(table(data$Diet_Type, useNA = "ifany")) %>%
    transmute(Variable = "Diet_Type", Level = as.character(Var1), Count = Freq),
  as.data.frame(table(data$Exercise_Frequency, useNA = "ifany")) %>%
    transmute(Variable = "Exercise_Frequency", Level = as.character(Var1), Count = Freq)
)

print(cat_counts)

# ============================================================
# (B) One-way ANOVA for categorical variables vs Cognitive_Score (Table 2.2.2)
# ============================================================

p_from_aov <- function(formula_obj, data_obj) {
  fit <- aov(formula_obj, data = data_obj)
  p <- summary(fit)[[1]][["Pr(>F)"]][1]
  as.numeric(p)
}

anova_results <- data.frame(
  Variable = c("Gender", "Diet_Type", "Exercise_Frequency"),
  Test = rep("One-way ANOVA", 3),
  p_value = c(
    p_from_aov(Cognitive_Score ~ Gender, data),
    p_from_aov(Cognitive_Score ~ Diet_Type, data),
    p_from_aov(Cognitive_Score ~ Exercise_Frequency, data)
  )
)

print(anova_results)

# Optional: pretty p-value formatting (e.g., "<0.001")
anova_results_pretty <- anova_results %>%
  mutate(p_value_pretty = ifelse(p_value < 0.001, "<0.001", sprintf("%.3f", p_value)))

print(anova_results_pretty)

# ============================================================
# (C) Visual support (Appendix 2.2): boxplots for categorical variables
# ============================================================

# Figure 2.2.1: Cognitive Score by Gender
ggplot(data, aes(x = Gender, y = Cognitive_Score, fill = Gender)) +
  geom_boxplot(outlier.alpha = 0.25) +
  labs(title = "Cognitive Score by Gender", x = "Gender", y = "Cognitive Score") +
  theme_minimal() +
  theme(legend.position = "none")

# Figure 2.2.2: Cognitive Score by Diet Type
ggplot(data, aes(x = Diet_Type, y = Cognitive_Score, fill = Diet_Type)) +
  geom_boxplot(outlier.alpha = 0.25) +
  labs(title = "Cognitive Score by Diet Type", x = "Diet Type", y = "Cognitive Score") +
  theme_minimal() +
  theme(legend.position = "none")

# Figure 2.2.3: Cognitive Score by Exercise Frequency
ggplot(data, aes(x = Exercise_Frequency, y = Cognitive_Score, fill = Exercise_Frequency)) +
  geom_boxplot(outlier.alpha = 0.25) +
  labs(title = "Cognitive Score by Exercise Frequency", x = "Exercise Frequency", y = "Cognitive Score") +
  theme_minimal() +
  theme(legend.position = "none")


# ============================================================
# (D) Example 1 — "Recode/merge" check for Gender (model comparison)
# Note: If your Gender2/Gender3 were only re-labeling/re-ordering levels,
# the models will be identical (same RSS/AIC). Adjust mapping if needed.
# ============================================================
# Ensure Gender is character for safe recoding
data$Gender <- as.character(data$Gender)

# ============================================================
# Base model: original 3 categories (Female/Male/Other)
# ============================================================
data$Gender3 <- factor(data$Gender, levels = c("Female", "Male", "Other"))
m_3cats <- lm(Cognitive_Score ~ Gender3, data = data)

# ============================================================
# Option A: Merge Other -> Female
# ============================================================
data$Gender_mergeF <- ifelse(data$Gender == "Other", "Female", data$Gender)
data$Gender_mergeF <- factor(data$Gender_mergeF, levels = c("Female", "Male"))

m_mergeF <- lm(Cognitive_Score ~ Gender_mergeF, data = data)

cat("\n--- Compare: 3 categories vs (Other -> Female) ---\n")
print(anova(m_3cats, m_mergeF))
print(AIC(m_3cats, m_mergeF))

# ============================================================
# Option B: Merge Other -> Male
# ============================================================
data$Gender_mergeM <- ifelse(data$Gender == "Other", "Male", data$Gender)
data$Gender_mergeM <- factor(data$Gender_mergeM, levels = c("Female", "Male"))

m_mergeM <- lm(Cognitive_Score ~ Gender_mergeM, data = data)

cat("\n--- Compare: 3 categories vs (Other -> Male) ---\n")
print(anova(m_3cats, m_mergeM))
print(AIC(m_3cats, m_mergeM))


# ============================================================
# (E) Example 2 — Discretization of a continuous variable: Age -> Age_group (quartiles)
# ============================================================

age_cuts <- quantile(data$Age, probs = c(0, 0.25, 0.50, 0.75, 1), na.rm = TRUE)
data$Age_group <- cut(
  data$Age,
  breaks = age_cuts,
  include.lowest = TRUE,
  labels = c("Q1", "Q2", "Q3", "Q4")
)

print(table(data$Age_group, useNA = "ifany"))

anova_age_group <- aov(Cognitive_Score ~ Age_group, data = data)
print(summary(anova_age_group))

# ============================================================
# (F) Example 3 — Create a new variable: Cognitive_Index from existing variables
# Logic: higher Memory_Test_Score is better; lower Reaction_Time is better.
# We standardize both, then combine.
# ============================================================

data$Cognitive_Index <- 
  as.numeric(scale(data$Memory_Test_Score)) - 
  as.numeric(scale(data$Reaction_Time))

# Relationship check with outcome
print(cor(data$Cognitive_Index, data$Cognitive_Score, use = "complete.obs"))

# Compare a "base" model (two predictors) vs the single-index model
m_base  <- lm(Cognitive_Score ~ Memory_Test_Score + Reaction_Time, data = data)
m_index <- lm(Cognitive_Score ~ Cognitive_Index, data = data)

print(AIC(m_base, m_index))
print(summary(m_base)$adj.r.squared)
print(summary(m_index)$adj.r.squared)


# ============================================================
# (G) Additional discretization example used: Daily_Screen_Time -> tertiles
# Compare continuous vs grouped using AIC (lower is preferred)
# ============================================================

cuts <- quantile(data$Daily_Screen_Time, probs = c(0, 1/3, 2/3, 1), na.rm = TRUE)
data$Screen_Time_Group <- cut(
  data$Daily_Screen_Time,
  breaks = cuts,
  include.lowest = TRUE,
  labels = c("Low", "Medium", "High")
)

print(table(data$Screen_Time_Group, useNA = "ifany"))

m_screen_cont <- lm(Cognitive_Score ~ Daily_Screen_Time, data = data)
m_screen_grp  <- lm(Cognitive_Score ~ Screen_Time_Group, data = data)

print(AIC(m_screen_cont, m_screen_grp))

# ============================================================
# (H) Continuous variables summary table (Table 2.2.3)
# ============================================================

cont_vars <- c(
  "Age",
  "Daily_Screen_Time",
  "Caffeine_Intake",
  "Reaction_Time",
  "Memory_Test_Score",
  "Sleep_Duration",
  "Cognitive_Score"
)

summary_table <- data.frame(
  Variable = cont_vars,
  N = sapply(cont_vars, function(v) sum(!is.na(data[[v]]))),
  Min = sapply(cont_vars, function(v) min(data[[v]], na.rm = TRUE)),
  Q1 = sapply(cont_vars, function(v) quantile(data[[v]], 0.25, na.rm = TRUE)),
  Median = sapply(cont_vars, function(v) median(data[[v]], na.rm = TRUE)),
  Mean = sapply(cont_vars, function(v) mean(data[[v]], na.rm = TRUE)),
  Q3 = sapply(cont_vars, function(v) quantile(data[[v]], 0.75, na.rm = TRUE)),
  Max = sapply(cont_vars, function(v) max(data[[v]], na.rm = TRUE)),
  SD = sapply(cont_vars, function(v) sd(data[[v]], na.rm = TRUE))
)

print(summary_table)






# =========================
# 2.3.1 - שכיחויות של Diet_Type
# (נספח 2.3.1)
# =========================
table(data$Diet_Type)


# =========================
# הכנה: סדר רמות אחיד + בניית שני המודלים (לא נספח בפני עצמו)
# =========================
data$Diet_Type <- factor(data$Diet_Type,
                         levels = c("Non-Vegetarian", "Vegetarian", "Vegan"))

# מודל מפורט (3 רמות)
m3 <- lm(Cognitive_Score ~ Diet_Type, data = data)

# איחוד Vegetarian + Vegan -> PlantBased
data$Diet_2 <- ifelse(data$Diet_Type == "Non-Vegetarian",
                      "Non-Vegetarian", "PlantBased")
data$Diet_2 <- factor(data$Diet_2, levels = c("Non-Vegetarian", "PlantBased"))

# מודל מאוחד (2 רמות)
m2 <- lm(Cognitive_Score ~ Diet_2, data = data)


# =========================
# 2.3.2 - השוואת מודלים לפי AIC
# (נספח 2.3.2)
# =========================
AIC(m3, m2)


# =========================
# 2.3.3 - השוואת מודלים (ANOVA)
# (נספח 2.3.3)
# =========================
anova(m2, m3)



2.4


2.4.1
library(ggplot2)

# Convert Stress_Level to factor for separate lines
data_imp_model$Stress_Factor <- factor(data_imp_model$Stress_Level)

# Optional: 5% sample to reduce clutter
set.seed(123)
n_5pct <- floor(0.05 * nrow(data_imp_model))
data_5pct <- data_imp_model[
  sample(seq_len(nrow(data_imp_model)), n_5pct),
]
ggplot(
  data_5pct,
  aes(
    x = Daily_Screen_Time,
    y = Cognitive_Score,
    color = Stress_Factor
  )
) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Cognitive_Score vs Daily_Screen_Time by Stress Level (1–10)",
    x = "Daily Screen Time (hours)",
    y = "Cognitive Score",
    color = "Stress Level"
  ) +
  theme_minimal()

מבחנים
# Base model
m_stress_base <- lm(
  Cognitive_Score ~ Daily_Screen_Time + Stress_Level,
  data = data_imp_model
)

# Interaction model
m_stress_int <- lm(
  Cognitive_Score ~ Daily_Screen_Time * Stress_Level,
  data = data_imp_model
)
anova(m_stress_base, m_stress_int)
AIC(m_stress_base, m_stress_int)


2.4.2
library(ggplot2)

# Stress as factor for visualization
data_imp_model$Stress_Factor <- factor(data_imp_model$Stress_Level)

# 5% sample to reduce clutter
set.seed(123)
n_5pct <- floor(0.05 * nrow(data_imp_model))
data_5pct <- data_imp_model[
  sample(seq_len(nrow(data_imp_model)), n_5pct),
]

ggplot(
  data_5pct,
  aes(
    x = Memory_Test_Score,
    y = Cognitive_Score,
    color = Stress_Factor
  )
) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Cognitive_Score vs Memory_Test_Score by Stress Level (1–10)",
    x = "Memory Test Score",
    y = "Cognitive Score",
    color = "Stress Level"
  ) +
  theme_minimal()

מבחנים
# Base model
m_mem_stress_base <- lm(
  Cognitive_Score ~ Memory_Test_Score + Stress_Level,
  data = data_imp_model
)

# Interaction model
m_mem_stress_int <- lm(
  Cognitive_Score ~ Memory_Test_Score * Stress_Level,
  data = data_imp_model
)

# Compare
anova(m_mem_stress_base, m_mem_stress_int)
AIC(m_mem_stress_base, m_mem_stress_int)

2.4.3
library(ggplot2)

set.seed(123)

# 5% sample for visualization
n_5pct <- floor(0.05 * nrow(data_imp_model))
data_5pct <- data_imp_model[
  sample(seq_len(nrow(data_imp_model)), n_5pct),
]

ggplot(
  data_5pct,
  aes(
    x = Daily_Screen_Time,
    y = Cognitive_Score,
    color = Diet_2
  )
) +
  geom_point(alpha = 0.25) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "Cognitive_Score vs Daily_Screen_Time by Diet Type (5% sample)",
    x = "Daily Screen Time (hours)",
    y = "Cognitive Score",
    color = "Diet Type"
  ) +
  theme_minimal()

מבחנים
m_screen_diet_base <- lm(
  Cognitive_Score ~ Daily_Screen_Time + Diet_2,
  data = data_imp_model
)

m_screen_diet_int <- lm(
  Cognitive_Score ~ Daily_Screen_Time * Diet_2,
  data = data_imp_model
)

anova(m_screen_diet_base, m_screen_diet_int)
AIC(m_screen_diet_base, m_screen_diet_int)



3.1
m_backward <- stepAIC(m_full, direction="backward", trace=FALSE)
m_null <- lm(Cognitive_Score ~ 1, data=data_imp_model)
m_forward  <- stepAIC(m_null, scope=list(lower=~1, upper=formula(m_full)),
                      direction="forward", trace=FALSE)

summary(m_forward)
AIC(m_backward, m_forward)
formula(m_forward)

3.2
# ============================================================
# 3.2 Diagnostics: Standardized residuals vs fitted + QQ plot
# Assumes your final model object is named: m_final
# ============================================================

# --- Safety check ---
stopifnot(exists("m_final"))

# --- Compute fitted values + standardized (normalized) residuals ---
fitted_vals <- fitted(m_final)
std_resid   <- rstandard(m_final)   # standardized residuals

# --- Plot 1: Standardized residuals vs fitted values ---
plot(
  x = fitted_vals,
  y = std_resid,
  xlab = "Fitted values",
  ylab = "Standardized residuals",
  main = "Standardized residuals vs Fitted values"
)
abline(h = 0, lty = 2)

# Optional: add a smooth trend line to help spot nonlinearity
lines(lowess(fitted_vals, std_resid), lwd = 2)

# --- Plot 2: QQ plot for standardized residuals ---
qqnorm(std_resid, main = "QQ Plot of Standardized residuals")
qqline(std_resid, lwd = 2)

3.3
set.seed(123)

# Standardized residuals from the final model
std_resid <- rstandard(m_final)

# 5% subsample
n_5pct <- floor(0.05 * length(std_resid))
std_resid_5pct <- sample(std_resid, n_5pct)

shapiro.test(std_resid_5pct)

ks.test(std_resid, "pnorm")

# מודל לינארי פשוט
m_lin_mem <- lm(
  Cognitive_Score ~ Memory_Test_Score,
  data = data_imp_model
)

# מודל לא לינארי (קיבוץ לפי ערכי Memory)
m_lof_mem <- lm(
  Cognitive_Score ~ as.factor(Memory_Test_Score),
  data = data_imp_model
)

# Lack Of Fit test
anova(m_lin_mem, m_lof_mem)

install.packages("strucchange")

library(strucchange)

library(strucchange)

# סדר הנתונים לפי Diet_2
data_chow <- data_imp_model[order(data_imp_model$Diet_2), ]

# נקודת חיתוך בין הקבוצות
break_point <- sum(data_chow$Diet_2 == "Non-Vegetarian")

# Chow test
sctest(
  Cognitive_Score ~
    Sleep_Duration +
    Stress_Level +
    Daily_Screen_Time +
    Exercise_Frequency +
    Caffeine_Intake +
    Reaction_Time +
    Memory_Test_Score +
    Diet_2,
  type  = "Chow",
  point = break_point,
  data  = data_chow
)


# ============================================================
# נספח קוד R – נספח 7 (שיפור מודל באמצעות טרנספורמציות)
# כולל: 7.1, 7.2, 7.3 (פלט אבחון ללא גרפים), 7.4, 7.5
# רץ כמו שהוא (ללא שינוי), בהנחה שקיימים: data_imp_model + fit
# ============================================================

# ---------- 0) בדיקות קיום אובייקטים ----------
stopifnot(exists("data_imp_model"))
stopifnot(exists("fit") && inherits(fit, "lm"))

m_base <- fit

# ---------- 7.1: מודל בסיס – AIC + Adjusted R^2 ----------
out <- data.frame(
  Base_Model = "best_model",
  AIC = AIC(m_base),
  Adj_R2 = summary(m_base)$adj.r.squared,
  stringsAsFactors = FALSE
)
print(out)

# ---------- 7.2: ניסיון טרנספורמציה (log ל-Daily_Screen_Time) + טבלת השוואה ----------
comp <- NULL
m_log <- NULL

base_terms <- attr(terms(m_base), "term.labels")
if ("Daily_Screen_Time" %in% base_terms && ("Daily_Screen_Time" %in% names(data_imp_model))) {

  m_log <- lm(
    update(formula(m_base), . ~ . - Daily_Screen_Time + log(Daily_Screen_Time)),
    data = data_imp_model
  )

  comp <- data.frame(
    Model = c("best_model", "base_with_log(Daily_Screen_Time)"),
    AIC = c(AIC(m_base), AIC(m_log)),
    Adj_R2 = c(summary(m_base)$adj.r.squared, summary(m_log)$adj.r.squared),
    Delta_AIC_vs_Base = c(0, AIC(m_log) - AIC(m_base)),
    Delta_AdjR2_vs_Base = c(0, summary(m_log)$adj.r.squared - summary(m_base)$adj.r.squared),
    stringsAsFactors = FALSE
  )

} else {
  comp <- data.frame(
    Model = "best_model",
    AIC = AIC(m_base),
    Adj_R2 = summary(m_base)$adj.r.squared,
    Delta_AIC_vs_Base = 0,
    Delta_AdjR2_vs_Base = 0,
    stringsAsFactors = FALSE
  )
}
print(comp)

# ---------- 7.3: פלט אבחון למודל שנבחר (ללא גרפים) ----------
# (רק מספרים שמסכמים את האבחון בצורה קריאה)
cat("\n--- Appendix 7.3: Diagnostic summary (no plots) ---\n")
cat("AIC =", round(AIC(m_base), 4), " | Adj-R2 =", round(summary(m_base)$adj.r.squared, 8), "\n")
cat("Residuals summary:\n")
print(summary(residuals(m_base)))
cat("Standardized residuals summary:\n")
print(summary(rstandard(m_base)))

# ---------- 7.4: בדיקת נורמליות לשאריות (מודל בסיס) – KS ----------
res_base <- rstandard(m_base)
ks_base <- ks.test(res_base, "pnorm", mean(res_base), sd(res_base))
print(ks_base)

# ---------- 7.5: נורמליות שאריות – Shapiro (עם דגימה אם N>5000) + KS + Jarque-Bera ----------
# Shapiro עובד רק עד 5000 -> עושים דגימה אוטומטית
shapiro_safe <- function(x, max_n = 5000, seed = 123) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  n <- length(x)
  if (n < 3) return(list(W = NA_real_, p.value = NA_real_, n_used = n, note = "n<3"))
  if (n > max_n) {
    set.seed(seed)
    x <- sample(x, max_n)
    note <- paste0("Shapiro computed on random sample of ", max_n, " (from n=", n, ")")
    n_used <- max_n
  } else {
    note <- paste0("Shapiro computed on full data (n=", n, ")")
    n_used <- n
  }
  sw <- shapiro.test(x)
  list(W = unname(sw$statistic), p.value = sw$p.value, n_used = n_used, note = note)
}

if (!requireNamespace("tseries", quietly = TRUE)) {
  install.packages("tseries")
}
library(tseries)

jb_safe <- function(x) {
  x <- as.numeric(x)
  x <- x[is.finite(x)]
  if (length(x) < 3) return(list(JB = NA_real_, p.value = NA_real_))
  jb <- tseries::jarque.bera.test(x)
  list(JB = unname(jb$statistic), p.value = jb$p.value)
}

# Base model tests
sw_b <- shapiro_safe(res_base)
ks_b <- ks.test(res_base, "pnorm", mean(res_base), sd(res_base))
jb_b <- jb_safe(res_base)

# Log model tests (if exists)
if (!is.null(m_log)) {
  res_log <- rstandard(m_log)
  sw_l <- shapiro_safe(res_log)
  ks_l <- ks.test(res_log, "pnorm", mean(res_log), sd(res_log))
  jb_l <- jb_safe(res_log)
  identical_res <- isTRUE(all.equal(as.numeric(res_base), as.numeric(res_log)))

  tab_7_5 <- data.frame(
    Model = c("Base", "Log(Daily_Screen_Time)"),
    AIC = c(AIC(m_base), AIC(m_log)),
    Adj_R2 = c(summary(m_base)$adj.r.squared, summary(m_log)$adj.r.squared),
    Shapiro_W = c(sw_b$W, sw_l$W),
    Shapiro_p = c(sw_b$p.value, sw_l$p.value),
    Shapiro_n_used = c(sw_b$n_used, sw_l$n_used),
    Shapiro_note = c(sw_b$note, sw_l$note),
    KS_D = c(unname(ks_b$statistic), unname(ks_l$statistic)),
    KS_p = c(ks_b$p.value, ks_l$p.value),
    JB_stat = c(jb_b$JB, jb_l$JB),
    JB_p = c(jb_b$p.value, jb_l$p.value),
    Residuals_Identical = c(NA, identical_res),
    stringsAsFactors = FALSE
  )

} else {
  tab_7_5 <- data.frame(
    Model = "Base (log model not created)",
    AIC = AIC(m_base),
    Adj_R2 = summary(m_base)$adj.r.squared,
    Shapiro_W = sw_b$W,
    Shapiro_p = sw_b$p.value,
    Shapiro_n_used = sw_b$n_used,
    Shapiro_note = sw_b$note,
    KS_D = unname(ks_b$statistic),
    KS_p = ks_b$p.value,
    JB_stat = jb_b$JB,
    JB_p = jb_b$p.value,
    Residuals_Identical = NA,
    stringsAsFactors = FALSE
  )
}

print(tab_7_5)




# ================================
# Appendix - Final model equation
# Prints the final model in plain English (no LaTeX)
# Assumes your final model object is: fit
# ================================

stopifnot(exists("fit") && inherits(fit, "lm"))

m_final <- fit

coefs <- coef(m_final)

# nice rounding (change 3 -> 2 if you want)
fmt <- function(x) format(round(x, 3), nsmall = 3, scientific = FALSE)

intercept <- fmt(coefs[1])
terms <- names(coefs)[-1]
vals  <- coefs[-1]

parts <- character(0)
for (i in seq_along(vals)) {
  sign <- ifelse(vals[i] >= 0, " + ", " - ")
  parts <- c(parts, paste0(sign, fmt(abs(vals[i])), " * ", terms[i]))
}

eq <- paste0("Cognitive_Score = ", intercept, paste0(parts, collapse = ""))

cat(eq, "\n")






# =========================
# APPENDIX H: Base model chosen + metrics
# =========================

stopifnot(exists("data_imp_model"))

# Find all lm models in GlobalEnv with response Cognitive_Score
lm_names <- ls(envir = .GlobalEnv)
lm_names <- lm_names[sapply(lm_names, function(nm) inherits(get(nm, envir=.GlobalEnv), "lm"))]

lm_names <- lm_names[sapply(lm_names, function(nm) {
  f <- try(formula(get(nm, envir=.GlobalEnv)), silent=TRUE)
  !inherits(f, "try-error") && as.character(f)[2] == "Cognitive_Score"
})]

if (length(lm_names) == 0) stop("No lm() model found with response Cognitive_Score.")

aics <- sapply(lm_names, function(nm) AIC(get(nm, envir=.GlobalEnv)))
base_name <- names(which.min(aics))
m_base <- get(base_name, envir=.GlobalEnv)

out <- data.frame(
  Base_Model = base_name,
  AIC = AIC(m_base),
  Adj_R2 = summary(m_base)$adj.r.squared
)

write.csv(out, "appendix_H_base_model_metrics.csv", row.names = FALSE)

cat("Saved: appendix_H_base_model_metrics.csv\n")
print(out)

     


# =========================
# APPENDIX T: Compare base vs log(Daily_Screen_Time)
# =========================

stopifnot(exists("data_imp_model"))

lm_names <- ls(envir = .GlobalEnv)
lm_names <- lm_names[sapply(lm_names, function(nm) inherits(get(nm, envir=.GlobalEnv), "lm"))]
lm_names <- lm_names[sapply(lm_names, function(nm) {
  f <- try(formula(get(nm, envir=.GlobalEnv)), silent=TRUE)
  !inherits(f, "try-error") && as.character(f)[2] == "Cognitive_Score"
})]
if (length(lm_names) == 0) stop("No lm() model found with response Cognitive_Score.")

aics <- sapply(lm_names, function(nm) AIC(get(nm, envir=.GlobalEnv)))
base_name <- names(which.min(aics))
m_base <- get(base_name, envir=.GlobalEnv)

# Safe log (handles 0/negative by shifting)
safe_log <- function(x){
  x <- as.numeric(x)
  if (min(x) <= 0) log(x + abs(min(x)) + 1) else log(x)
}

# Only run the trial if Daily_Screen_Time is in the base model
base_terms <- attr(terms(m_base), "term.labels")
if (!("Daily_Screen_Time" %in% base_terms)) {
  stop("Daily_Screen_Time is not in the base model terms, so this trial is not applicable.")
}

data_imp_model$log_Daily_Screen_Time <- safe_log(data_imp_model$Daily_Screen_Time)

m_log_screen <- lm(
  update(formula(m_base), . ~ . - Daily_Screen_Time + log_Daily_Screen_Time),
  data = data_imp_model
)

comp <- data.frame(
  Model = c(base_name, "base_with_log(Daily_Screen_Time)"),
  AIC = c(AIC(m_base), AIC(m_log_screen)),
  Adj_R2 = c(summary(m_base)$adj.r.squared, summary(m_log_screen)$adj.r.squared),
  Delta_AIC_vs_Base = c(0, AIC(m_log_screen) - AIC(m_base)),
  Delta_AdjR2_vs_Base = c(0, summary(m_log_screen)$adj.r.squared - summary(m_base)$adj.r.squared)
)

write.csv(comp, "appendix_T_compare_base_vs_log_screen.csv", row.names = FALSE)

cat(" Saved: appendix_T_compare_base_vs_log_screen.csv\n")
print(comp)



# =========================
# APPENDIX Y: Diagnostic plots for the chosen model in Section 4
# =========================

stopifnot(exists("data_imp_model"))

# Auto-pick base model
lm_names <- ls(envir = .GlobalEnv)
lm_names <- lm_names[sapply(lm_names, function(nm) inherits(get(nm, envir=.GlobalEnv), "lm"))]
lm_names <- lm_names[sapply(lm_names, function(nm) {
  f <- try(formula(get(nm, envir=.GlobalEnv)), silent=TRUE)
  !inherits(f, "try-error") && as.character(f)[2] == "Cognitive_Score"
})]
if (length(lm_names) == 0) stop("No lm() model found with response Cognitive_Score.")

aics <- sapply(lm_names, function(nm) AIC(get(nm, envir=.GlobalEnv)))
base_name <- names(which.min(aics))
m_base <- get(base_name, envir=.GlobalEnv)

# Build the log(Daily_Screen_Time) trial if applicable
base_terms <- attr(terms(m_base), "term.labels")

chosen_name <- base_name
m_chosen <- m_base

if ("Daily_Screen_Time" %in% base_terms) {

  safe_log <- function(x){
    x <- as.numeric(x)
    if (min(x) <= 0) log(x + abs(min(x)) + 1) else log(x)
  }

  data_imp_model$log_Daily_Screen_Time <- safe_log(data_imp_model$Daily_Screen_Time)

  m_log_screen <- lm(
    update(formula(m_base), . ~ . - Daily_Screen_Time + log_Daily_Screen_Time),
    data = data_imp_model
  )

  # Decision rule: keep log only if AIC improves by at least 2
  if (AIC(m_log_screen) <= AIC(m_base) - 2) {
    chosen_name <- "chosen_log(Daily_Screen_Time)"
    m_chosen <- m_log_screen
  }
}

png_file <- paste0("appendix_Y_diagnostics_", chosen_name, ".png")

png(png_file, width = 1400, height = 700)
par(mfrow = c(1,2))
plot(m_chosen, which = 1)  # Residuals vs Fitted
plot(m_chosen, which = 2)  # QQ plot
par(mfrow = c(1,1))
dev.off()

cat(" Saved:", png_file, "\n")
cat("Chosen model for Section 4:", chosen_name, "\n")
cat("AIC =", AIC(m_chosen), " | Adj-R2 =", summary(m_chosen)$adj.r.squared, "\n")



# ============================================
# Appendix 7.4 – Normality tests (base model)
# ============================================

res_base <- rstandard(fit)

# Shapiro-Wilk (רגיש למדגמים קטנים)
shapiro_base <- shapiro.test(res_base)
print(shapiro_base)

# Kolmogorov-Smirnov
ks_base <- ks.test(res_base, "pnorm", mean(res_base), sd(res_base))
print(ks_base)




# -----------------------------
# Clean Box-Cox plot (no overlap)
# -----------------------------

plot(
  bc$x, bc$y, type = "l",
  main = "Box-Cox for Cognitive_Score",
  xlab = expression(lambda),
  ylab = "Log-likelihood"
)

# Lines
abline(v = lambda_hat, lwd = 2)
abline(v = lambda_ci, lty = 2, lwd = 2)
abline(v = 1, lty = 3, lwd = 2)

# Legend (kept minimal)
legend(
  "bottomright",
  legend = c(expression(lambda^"*"), "95% CI", expression(lambda == 1)),
  lty = c(1, 2, 3),
  lwd = 2,
  bty = "n"
)

# ---- Text in a free corner (top-left) ----
usr <- par("usr")

text_x <- usr[1] + 0.05 * (usr[2] - usr[1])
text_y <- usr[4] - 0.10 * (usr[4] - usr[3])

label_txt <- paste0(
  "lambda* = ", round(lambda_hat, 2), "\n",
  "95% CI = [", round(lambda_ci[1], 2), ", ",
  round(lambda_ci[2], 2), "]"
)

text(
  x = text_x,
  y = text_y,
  labels = label_txt,
  adj = c(0, 1),
  cex = 0.9
)


# ============================================================
# Section 4 - Test AGE (linear + transformations) vs base model
# Requires: data_imp_model already exists
# ============================================================

stopifnot(exists("data_imp_model"))

# --- 0) Make sure Age exists and is numeric
# Change "Age" here if your column name is different (e.g., "AGE")
if (!("Age" %in% names(data_imp_model))) {
  stop("Column 'Age' was not found in data_imp_model. Rename it in the code to match your dataset.")
}

data_imp_model$Age <- as.numeric(data_imp_model$Age)

# Remove rows with missing/invalid Age for fair comparison across models
d_age <- subset(data_imp_model, !is.na(Age) & is.finite(Age) & Age > 0)

# --- 1) Base model (your improved model WITHOUT Age)
m_base <- lm(
  Cognitive_Score ~
    Sleep_Duration +
    Stress_Level +
    Daily_Screen_Time +
    Exercise_Frequency +
    Caffeine_Intake +
    Reaction_Time +
    Memory_Test_Score +
    Diet_2,
  data = d_age
)

# --- 2) Age linear
m_age_lin <- update(m_base, . ~ . + Age)

# --- 3) Age transformations
m_age_log  <- update(m_base, . ~ . + log(Age))
m_age_sqrt <- update(m_base, . ~ . + sqrt(Age))

# --- 4) Polynomial (degree 2)
m_age_poly2 <- update(m_base, . ~ . + Age + I(Age^2))
# Alternative (orthogonal poly): update(m_base, . ~ . + poly(Age, 2))

# --- 5) Collect model comparison metrics
model_list <- list(
  base      = m_base,
  age_lin   = m_age_lin,
  age_log   = m_age_log,
  age_sqrt  = m_age_sqrt,
  age_poly2 = m_age_poly2
)

get_metrics <- function(m) {
  s <- summary(m)
  data.frame(
    AIC = AIC(m),
    Adj_R2 = s$adj.r.squared,
    RSE = s$sigma,
    stringsAsFactors = FALSE
  )
}

metrics <- do.call(rbind, lapply(model_list, get_metrics))
metrics$model <- rownames(metrics)
metrics <- metrics[, c("model", "AIC", "Adj_R2", "RSE")]
metrics <- metrics[order(metrics$AIC), ]

print(metrics)

# --- 6) Show coefficient table for AGE term(s) in each model
cat("\n\n================ Coefficients (Age terms) ================\n")
cat("\n--- age_lin ---\n");  print(coef(summary(m_age_lin))["Age", , drop=FALSE])

cat("\n--- age_log ---\n");  print(coef(summary(m_age_log))["log(Age)", , drop=FALSE])

cat("\n--- age_sqrt ---\n"); print(coef(summary(m_age_sqrt))["sqrt(Age)", , drop=FALSE])

cat("\n--- age_poly2 ---\n")
print(coef(summary(m_age_poly2))[c("Age", "I(Age^2)"), , drop=FALSE])

# --- 7) Optional: nested model tests (F-test) vs base
# (Works because each model is base + extra term(s))
cat("\n\n================ ANOVA vs base (nested F-test) ================\n")
print(anova(m_base, m_age_lin))
print(anova(m_base, m_age_log))
print(anova(m_base, m_age_sqrt))
print(anova(m_base, m_age_poly2))



M0 <- lm(
  Cognitive_Score ~ Sleep_Duration + Stress_Level + Daily_Screen_Time +
    Exercise_Frequency + Reaction_Time + Memory_Test_Score + Diet_2 +
    Caffeine_Intake + I(Caffeine_Intake^2),
  data = data_imp_model
)

Mpoly <- lm(
  Cognitive_Score ~ Sleep_Duration + Stress_Level + I(Stress_Level^2) + Daily_Screen_Time +
    Exercise_Frequency + Reaction_Time + Memory_Test_Score + Diet_2 +
    Caffeine_Intake + I(Caffeine_Intake^2),
  data = data_imp_model
)

Mint <- lm(
  Cognitive_Score ~ Sleep_Duration + Stress_Level + Daily_Screen_Time +
    Exercise_Frequency + Reaction_Time + Memory_Test_Score + Diet_2 +
    Caffeine_Intake + I(Caffeine_Intake^2) +
    Memory_Test_Score:Stress_Level,
  data = data_imp_model
)

Mboth <- lm(
  Cognitive_Score ~ Sleep_Duration + Stress_Level + I(Stress_Level^2) + Daily_Screen_Time +
    Exercise_Frequency + Reaction_Time + Memory_Test_Score + Diet_2 +
    Caffeine_Intake + I(Caffeine_Intake^2) +
    Memory_Test_Score:Stress_Level,
  data = data_imp_model
)

metrics <- data.frame(
  model = c("M0_base", "Mpoly_stress2", "Mint_interaction", "Mboth_both"),
  AIC   = c(AIC(M0), AIC(Mpoly), AIC(Mint), AIC(Mboth)),
  Adj_R2= c(summary(M0)$adj.r.squared,
            summary(Mpoly)$adj.r.squared,
            summary(Mint)$adj.r.squared,
            summary(Mboth)$adj.r.squared),
  RSE   = c(summary(M0)$sigma,
            summary(Mpoly)$sigma,
            summary(Mint)$sigma,
            summary(Mboth)$sigma)
)
print(metrics)

# ===== 2) מבחני ANOVA (F-test) למודלים מקוננים =====

print(anova(M0, Mpoly))

print(anova(M0, Mint))

print(anova(Mpoly, Mboth))



