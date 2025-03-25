local ball = workspace:FindFirstChild("Football")

           if ball then
               local highlight = ball:FindFirstChild("ESP") or Instance.new("Highlight")
               highlight.Name = "ESP"
               highlight.FillColor = Color3.fromRGB(255, 255, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
               highlight.Adornee = ball
               highlight.Parent = ball
           end
       end
   end
})
