#!/usr/bin/env Rscript

# R语言贪吃蛇游戏
# 包含障碍物和撞墙死亡功能
# 使用基础图形功能，不依赖X11

# 游戏参数设置
width <- 20  # 游戏区域宽度
height <- 10  # 游戏区域高度

# 游戏符号
SNAKE_HEAD <- "@"  # 蛇头
SNAKE_BODY <- "o"  # 蛇身
FOOD <- "*"        # 食物
OBSTACLE <- "#"    # 障碍物
EMPTY <- "."       # 空白区域
BORDER <- "+"      # 边界

# 初始化游戏状态
initialize_game <- function() {
  # 创建游戏区域
  game_area <<- matrix(EMPTY, nrow = height, ncol = width)
  
  # 创建蛇的初始位置（中心位置）
  snake_x <<- c(floor(width/2), floor(width/2)-1, floor(width/2)-2)
  snake_y <<- c(floor(height/2), floor(height/2), floor(height/2))
  
  # 初始方向（右）
  direction <<- "right"
  
  # 初始化障碍物
  create_obstacles()
  
  # 初始化食物位置
  place_food()
  
  # 游戏状态
  game_over <<- FALSE
  score <<- 0
  
  # 更新游戏区域
  update_game_area()
}

# 创建障碍物
create_obstacles <- function() {
  # 初始化障碍物列表
  obstacle_x <<- c()
  obstacle_y <<- c()
  
  # 添加5个随机障碍物
  for (i in 1:5) {
    repeat {
      # 生成随机位置
      ox <- sample(2:(width-1), 1)
      oy <- sample(2:(height-1), 1)
      
      # 确保障碍物不在蛇的位置上
      if (!any(snake_x == ox & snake_y == oy)) {
        obstacle_x <<- c(obstacle_x, ox)
        obstacle_y <<- c(obstacle_y, oy)
        break
      }
    }
  }
  
  # 将障碍物放入游戏区域
  for (i in 1:length(obstacle_x)) {
    game_area[obstacle_y[i], obstacle_x[i]] <<- OBSTACLE
  }
}

# 放置食物
place_food <- function() {
  repeat {
    # 随机生成食物位置
    food_x <<- sample(2:(width-1), 1)
    food_y <<- sample(2:(height-1), 1)
    
    # 确保食物不在蛇身或障碍物上
    if (!any(snake_x == food_x & snake_y == food_y) && 
        !any(obstacle_x == food_x & obstacle_y == food_y)) {
      game_area[food_y, food_x] <<- FOOD
      break
    }
  }
}

# 更新游戏区域
update_game_area <- function() {
  # 重置游戏区域（保留障碍物）
  game_area <<- matrix(EMPTY, nrow = height, ncol = width)
  
  # 添加边界
  game_area[1, ] <<- BORDER
  game_area[height, ] <<- BORDER
  game_area[, 1] <<- BORDER
  game_area[, width] <<- BORDER
  
  # 添加障碍物
  for (i in 1:length(obstacle_x)) {
    game_area[obstacle_y[i], obstacle_x[i]] <<- OBSTACLE
  }
  
  # 添加食物
  game_area[food_y, food_x] <<- FOOD
  
  # 添加蛇
  for (i in 1:length(snake_x)) {
    if (i == 1) {
      game_area[snake_y[i], snake_x[i]] <<- SNAKE_HEAD
    } else {
      game_area[snake_y[i], snake_x[i]] <<- SNAKE_BODY
    }
  }
}

# 绘制游戏
draw_game <- function() {
  # 清屏
  cat("\033[2J\033[H")
  
  # 显示分数
  cat(paste("分数:", score, "\n"))
  
  # 绘制游戏区域
  for (y in 1:height) {
    for (x in 1:width) {
      cat(game_area[y, x])
    }
    cat("\n")
  }
  
  # 显示控制说明
  cat("\n控制: w(上) a(左) s(下) d(右) q(退出)\n")
  
  # 如果游戏结束，显示游戏结束信息
  if (game_over) {
    cat("\n游戏结束！按r键重新开始\n")
  }
}

# 移动蛇
move_snake <- function() {
  # 保存蛇头的当前位置
  head_x <- snake_x[1]
  head_y <- snake_y[1]
  
  # 根据方向移动蛇头
  if (direction == "right") {
    head_x <- head_x + 1
  } else if (direction == "left") {
    head_x <- head_x - 1
  } else if (direction == "up") {
    head_y <- head_y - 1
  } else if (direction == "down") {
    head_y <- head_y + 1
  }
  
  # 检查是否撞墙
  if (head_x <= 1 || head_x >= width || head_y <= 1 || head_y >= height) {
    game_over <<- TRUE
    return()
  }
  
  # 检查是否撞到自己（从第2个身体部分开始检查，避免与蛇头自身比较）
  if (length(snake_x) > 1) {
    for (i in 2:length(snake_x)) {
      if (head_x == snake_x[i] && head_y == snake_y[i]) {
        game_over <<- TRUE
        return()
      }
    }
  }
  
  # 检查是否撞到障碍物
  if (any(obstacle_x == head_x & obstacle_y == head_y)) {
    game_over <<- TRUE
    return()
  }
  
  # 检查是否吃到食物
  if (head_x == food_x && head_y == food_y) {
    # 增加分数
    score <<- score + 1
    
    # 不移除蛇尾（蛇变长）
    snake_x <<- c(head_x, snake_x)
    snake_y <<- c(head_y, snake_y)
    
    # 放置新食物
    place_food()
  } else {
    # 移动蛇（移除尾部，添加新头部）
    snake_x <<- c(head_x, snake_x[1:(length(snake_x)-1)])
    snake_y <<- c(head_y, snake_y[1:(length(snake_y)-1)])
  }
  
  # 更新游戏区域
  update_game_area()
}

# 游戏主循环
game_loop <- function() {
  # 初始化游戏
  initialize_game()
  
  # 绘制初始游戏状态
  draw_game()
  
  # 游戏循环
  while (!game_over) {
    # 获取用户输入
    cat("请输入方向 (w/a/s/d): ")
    input <- tryCatch({
      tolower(readLines(n=1, warn=FALSE))
    }, error = function(e) {
      ""
    })
    
    # 确保input不是NULL或NA
    if (length(input) == 0 || is.na(input)) {
      input <- ""
    }
    
    # 处理用户输入
    if (input == "w" && direction != "down") {
      direction <<- "up"
    } else if (input == "a" && direction != "right") {
      direction <<- "left"
    } else if (input == "s" && direction != "up") {
      direction <<- "down"
    } else if (input == "d" && direction != "left") {
      direction <<- "right"
    } else if (input == "q") {
      # 退出游戏
      cat("游戏已退出\n")
      return()
    } else if (input == "r") {
      # 重新开始游戏
      initialize_game()
      draw_game()
      next
    }
    
    # 移动蛇
    move_snake()
    
    # 绘制游戏
    draw_game()
    
    # 如果游戏结束，询问是否重新开始
     if (game_over) {
       cat("游戏结束！是否重新开始？(y/n): ")
       restart <- tryCatch({
         tolower(readLines(n=1, warn=FALSE))
       }, error = function(e) {
         ""
       })
       
       # 确保restart不是NULL或NA
       if (length(restart) == 0 || is.na(restart)) {
         restart <- ""
       }
       
       if (restart == "y") {
         initialize_game()
         draw_game()
       } else {
         cat("游戏已退出\n")
         break
       }
     }
  }
}

# 开始游戏
cat("欢迎来到R语言贪吃蛇游戏！\n")
cat("按Enter键开始游戏...")
invisible(readLines(n=1))
# 直接调用游戏循环函数
game_loop()