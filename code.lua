dirs = {
    [0] = {x = 0, y = -1}, --up
    [1] = {x = 0, y = 1}, --down
    [2] = {x = -1, y = 0}, --left
    [3] = {x = 1, y = 0} --right
}

function update()
    return t%10 == 0
end

function gotFood()
    if head.x == food.x and head.y == food.y then
        return true
    end
end
function gotFood2()
    if head2.x == food.x and head2.y == food.y then
        return true
    end
end

function setFood()
    food.x = math.random(0, 28)
    food.y = math.random(0, 18)
    food.id = math.random(2, 4)
    for i, v in pairs(snake) do
        if v.x == food.x and v.y == food.y then
            setFood()
        end
    end
    for i, v in pairs(snake2) do
        if v.x == food.x and v.y == food.y then
            setFood()
        end
    end
end

function draw()
    DrawText("p1 score: "..score, 1, 1, DrawMode.Sprite, "large", 3)
    DrawText("p2 score: "..score2, 1, 140, DrawMode.Sprite, "large", 3)
    for i, v in pairs(snake) do
        DrawSprite(0, v.x * 8, v.y * 8, false, false, null, 0)
    end
    for i, v in pairs(snake2) do
        DrawSprite(1, v.x * 8, v.y * 8, false, false, null, 0)
    end
    DrawSprite(food.id, food.x * 8, food.y * 8, false, false, null, 0)

end

function newGame()
    t = 0 --time
    score = 0
    score2 = 0
    snake = {
        {x = 14, y = 10}, --tail
        {x = 14, y = 9}, --neck
        {x = 14, y = 8} --head
    }
    snake2 = {
        {x = 16, y = 10}, --tail
        {x = 16, y = 9}, --neck
        {x = 16, y = 8} --head
    }
    food = {x = math.random(0, 28), y = math.random(0, 18), id = 3}
    dir = dirs[0]
    dir2 = dirs[0]
end

function Init()
    first = true
    gameOver = true
    BackgroundColor(0)
    PlaySong({0}, false)
end

function Update(timeDelta)

end

function Draw()
    RedrawDisplay()
    if(gameOver and Button(Buttons.A)) then
        gameOver = false
        first = false
        newGame()
    end
    if(gameOver) then
        if(not first) then
            DrawText("Game over, ", 1, 1, DrawMode.Sprite, "large", 3)
            DrawText(loser.." ate themselves!", 1, 10, DrawMode.Sprite, "large", 3)
            DrawText("Final score, p1: "..score.." , p2: "..score2, 1, 20, DrawMode.Sprite, "large", 3)
        else
            DrawText("Snek 2 player!", 1, 20, DrawMode.Sprite, "large", 3)
        end
        DrawText("Press button to play.", 1, 30, DrawMode.Sprite, "large", 3)
    else
        t = t + 1
        head = snake[#snake]
        neck = snake[#snake - 1]
        tail = snake[1]

        head2 = snake2[#snake2]
        neck2 = snake2[#snake2 - 1]
        tail2 = snake2[1]
        if update() then

            for i, v in pairs(snake) do
                if i ~= #snake and v.x == head.x and v.y == head.y then
                    --implement end game
                    gameOver = true
                    loser = "Player 1"
                end
            end
            for i, v in pairs(snake2) do
                if i ~= #snake2 and v.x == head2.x and v.y == head2.y then
                    --implement end game
                    gameOver = true
                    loser = "Player 2"
                end
            end

            table.insert(snake, #snake + 1, {x = (head.x + dir.x)%29, y = (head.y + dir.y)%19})
            if not gotFood() then
                table.remove(snake, 1)
            else
                PlaySound(10, 0)
                setFood()
                score = score + 1
            end
            table.insert(snake2, #snake2 + 1, {x = (head2.x + dir2.x)%29, y = (head2.y + dir2.y)%19})
            if not gotFood2() then
                table.remove(snake2, 1)
            else
                PlaySound(11, 0)
                setFood()
                score2 = score2 + 1
            end

        end

        local last_dir = dir
        local last_dir2 = dir2

        if Button(Buttons.Up, InputState.Down, 0) then dir = dirs[0]
        elseif Button(Buttons.Down, InputState.Down, 0) then dir = dirs[1]
        elseif Button(Buttons.Left, InputState.Down, 0) then dir = dirs[2]
        elseif Button(Buttons.Right, InputState.Down, 0) then dir = dirs[3]
        end

        if Button(Buttons.Up, InputState.Down, 1) then dir2 = dirs[0]
        elseif Button(Buttons.Down, InputState.Down, 1) then dir2 = dirs[1]
        elseif Button(Buttons.Left, InputState.Down, 1) then dir2 = dirs[2]
        elseif Button(Buttons.Right, InputState.Down, 1) then dir2 = dirs[3]
        end

        if head.x + dir.x == neck.x and head.y + dir.y == neck.y then
            dir = last_dir
        end
        if head2.x + dir2.x == neck2.x and head2.y + dir2.y == neck2.y then
            dir2 = last_dir2
        end

        draw()
    end
end
