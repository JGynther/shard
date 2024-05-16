CC_RAYLIB_InitWindow(800, 450, "Raylib from Lua!")

while (not CC_RAYLIB_WindowShouldClose()) do
    CC_RAYLIB_BeginDrawing()
    CC_RAYLIB_EndDrawing()
end

CC_RAYLIB_CloseWindow()
