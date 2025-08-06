# R Language Chart Examples
# Clean environment
rm(list = ls())

# Load necessary packages
library(ggplot2)

# ===== Basic Chart Examples =====

# 1. Bar Chart Example
cat("\n1. Creating Bar Chart...\n")
dat <- data.frame(
  time = factor(c("Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(14.89, 17.23)
)
print(dat)

p1 <- ggplot(data=dat, aes(x=time, y=total_bill, fill=time)) +
    geom_bar(stat="identity") +
    labs(title="Meal Time vs Total Bill", x="Meal Time", y="Total Bill") +
    theme_minimal()
print(p1)
ggsave("r/image/餐饮账单_meal_bill_plot.png", plot=p1, width=8, height=6, dpi=300)

# 2. Scatter Plot Example
cat("\n2. Creating Scatter Plot...\n")
# Create sample data
set.seed(123)
x <- rnorm(50)
y <- x + rnorm(50, sd=0.5)
scatter_data <- data.frame(x=x, y=y)

p2 <- ggplot(scatter_data, aes(x=x, y=y)) +
    geom_point(color="blue", size=3, alpha=0.7) +
    geom_smooth(method="lm", color="red") +
    labs(title="Scatter Plot with Linear Regression", x="X Value", y="Y Value") +
    theme_minimal()
print(p2)
ggsave("r/image/散点图_scatter_plot.png", plot=p2, width=8, height=6, dpi=300)

# 3. Histogram Example
cat("\n3. Creating Histogram...\n")
set.seed(456)
data <- data.frame(value = rnorm(200))

p3 <- ggplot(data, aes(x=value)) +
    geom_histogram(bins=20, fill="skyblue", color="black") +
    labs(title="Normal Distribution Histogram", x="Value", y="Frequency") +
    theme_minimal()
print(p3)
ggsave("r/image/直方图_histogram_plot.png", plot=p3, width=8, height=6, dpi=300)

# 4. Box Plot Example
cat("\n4. Creating Box Plot...\n")
set.seed(789)
box_data <- data.frame(
  group = rep(c("A", "B", "C"), each=30),
  value = c(rnorm(30, mean=5, sd=1), rnorm(30, mean=7, sd=1.5), rnorm(30, mean=4, sd=2))
)

p4 <- ggplot(box_data, aes(x=group, y=value, fill=group)) +
    geom_boxplot() +
    labs(title="Box Plot Comparison Between Groups", x="Group", y="Value") +
    theme_minimal()
print(p4)
ggsave("r/image/箱线图_boxplot.png", plot=p4, width=8, height=6, dpi=300)

# 5. Line Chart Example
cat("\n5. Creating Line Chart...\n")
time_data <- data.frame(
  time = 1:20,
  value = cumsum(rnorm(20))
)

p5 <- ggplot(time_data, aes(x=time, y=value)) +
    geom_line(color="purple", linewidth=1) +
    geom_point(color="purple", size=3) +
    labs(title="Time Series Line Chart", x="Time", y="Cumulative Value") +
    theme_minimal()
print(p5)
ggsave("r/image/折线图_line_plot.png", plot=p5, width=8, height=6, dpi=300)

# 6. Density Plot Example
cat("\n6. Creating Density Plot...\n")
set.seed(101)
density_data <- data.frame(
  group = rep(c("Group 1", "Group 2"), each=100),
  value = c(rnorm(100, mean=0, sd=1), rnorm(100, mean=2, sd=0.8))
)

p6 <- ggplot(density_data, aes(x=value, fill=group)) +
    geom_density(alpha=0.5) +
    labs(title="Density Distribution Comparison Between Groups", x="Value", y="Density") +
    theme_minimal()
print(p6)
ggsave("r/image/密度图_density_plot.png", plot=p6, width=8, height=6, dpi=300)

cat("\n所有图表已生成并保存为中英文命名的PNG文件!\n\n文件列表:\n1. 餐饮账单_meal_bill_plot.png\n2. 散点图_scatter_plot.png\n3. 直方图_histogram_plot.png\n4. 箱线图_boxplot.png\n5. 折线图_line_plot.png\n6. 密度图_density_plot.png\n")
