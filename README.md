
---

# Snake Game - Assembly Language Project

## Overview

This project implements the classic **Snake Game** using assembly language for the Intel 8086 architecture. The game was developed using **NASM** and run through **DOSBox**, demonstrating a variety of low-level programming concepts such as memory addressing, branching, interrupts, and input handling.

## Features

### 1. Introduction
The game begins with a welcome message and project information, followed by game instructions. The objective of the game is to control a snake, collect food, and grow in size, while avoiding collisions with the game boundaries and the snake’s own body.
![image](https://github.com/user-attachments/assets/16de7698-54f0-433e-9b28-b90537628161)
![image](https://github.com/user-attachments/assets/8f7f4446-a42b-46c7-abc1-408d8906bbbb)


### 2. Game Objective
- **Snake Control**: The player uses arrow keys to move the snake in four directions (Up, Down, Left, Right).
- **Food Collection**: The snake must collect randomly placed food on the screen to grow longer.
- **Collision Detection**: If the snake collides with the game boundaries or itself, the game is over.

### 3. Key Game Components

#### 3.1 Player Input
Player input is handled through the `play_game` subroutine. The snake’s movement is controlled using the arrow keys (Up, Down, Left, Right), and the game loop processes these inputs in real-time.
![image](https://github.com/user-attachments/assets/0a32140e-29c6-4caf-b2ff-3c93dfcfbea5)

#### 3.2 Snake Movement
The snake moves according to the player's input using subroutines like `move_snake_up`, `move_snake_down`, `move_snake_left`, and `move_snake_right`. Each subroutine updates the snake's position on the screen by writing to the video memory at address `0xb800`.
![image](https://github.com/user-attachments/assets/0e20b9bf-bc17-463a-8471-3a0130bdf0d5)

#### 3.3 Collision Detection
The `check_death` subroutine monitors the snake’s position and determines whether it has collided with the boundaries of the game area or with itself. If a collision is detected, the game calls the `over` subroutine to display the "Game Over" message.

#### 3.4 Scoring System
The score is incremented each time the snake eats food. The player's score is displayed using the `printScore` subroutine, which prints the score on the screen in real-time.

#### 3.5 Game Over
When the game detects a collision, the `exitGame` subroutine is called to clear the screen and display the final score along with the "Game Over" message.

### 4. Game Development Tools
The game was developed using the following tools:
- **NASM (Netwide Assembler)**: For writing and compiling the assembly language code.
- **DOSBox**: For running the game in a DOS-like environment on modern systems.

### 5. Code Breakdown

- **Player Input**: Controlled using BIOS interrupts to capture arrow key presses and move the snake accordingly.
- **Snake Rendering**: The snake is rendered on the screen by writing to the video memory, with the starting coordinates and size of the snake defined in memory.
- **Food Placement**: Food is randomly placed on the screen using the `displayFood` subroutine.
- **Score Calculation**: The score increases as the snake collects food, and is updated on the screen in real-time.

### 6. How to Run the Game

1. **Install DOSBox**: The game requires DOSBox to run on modern operating systems.
   - Download and install DOSBox from [here](https://www.dosbox.com/).

2. **Compile the Code**: Use **NASM** to compile the game code.
   ```bash
   nasm -f bin snake_game.asm -o snake_game.com
   ```

3. **Run the Game**: Launch DOSBox and run the compiled `.com` file.
   ```bash
   snake_game.com
   ```

4. **Gameplay**: Use the arrow keys to move the snake, collect food, and avoid collisions. Press 'Enter' to start the game from the instructions screen.

### 7. Controls
- **Arrow Keys**: Move the snake up, down, left, or right.
- **Enter**: Start the game after reading the instructions.

### 8. Game Over Condition
- The game ends when the snake collides with the boundaries or itself.
- The final score will be displayed along with a "Game Over" message.

### 9. Contributors
- **Muhammad Tayyab Khan** - 22F-3440
- **Azam Rafique** - 22F-8766

---
