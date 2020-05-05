local widgetInformation = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 200, 300, 150, 150)

local toolBar = plugin:CreateToolbar("Studio Simulator")
local toolBarButton = toolBar:CreateButton("Play Studio Simulator!", "Opens/Closes the widget", "")
local testWidget = plugin:CreateDockWidgetPluginGui("Test", widgetInformation)
testWidget.Title = "Studio Simulator"

toolBarButton.Click:Connect(function()
	testWidget.Enabled = not testWidget.Enabled
end)

local function updateObjectTest(object, text)
	object.Text = text
end

local PlayerUpgrades = {}

local DefaultTable = 
{
["Counter"] = 0,
["ClicksPerSecond"] = 0,
}

local UpgradeDictionary = {
["2nd Upgrade"] = {["Price"] = 25, ["ClicksPerSecond"] = 1, ["TemporaryPrice"] = 25, ["GrowthRate"] = 1.15},
["1st Upgrade"] = {["Price"] = 10, ["ClicksPerSecond"] = 0.1, ["TemporaryPrice"] = 10, ["GrowthRate"] = 1.07}
}


--Variable Setup
local Key = "Stats"
local PlayerTableLoad = plugin:GetSetting(Key)
if not PlayerTableLoad then
	print("No prior player data found, default values being set!")
	PlayerTableLoad = DefaultTable
else print("Player data found!") print("Counter: "..PlayerTableLoad["Counter"]) print("Clicks per second: "..PlayerTableLoad["ClicksPerSecond"]) PlayerUpgrades = PlayerTableLoad["PlayerUpgrades"] or {} end

local function RecalculateCost()
	for name, upgradeTable in pairs(UpgradeDictionary) do
		local PlayerUpgradeName = PlayerTableLoad["PlayerUpgrades"][name]
		local AmountOwned
		if not PlayerUpgradeName then AmountOwned = 0 else AmountOwned = PlayerUpgradeName["UpgradeCounter"] end
		upgradeTable["TemporaryPrice"] = upgradeTable["Price"] * math.pow(upgradeTable["GrowthRate"], AmountOwned)
	end
end

local UIContstraint = Instance.new("UIAspectRatioConstraint")
UIContstraint.AspectRatio = 0.667
UIContstraint.Parent = testWidget


local Button = Instance.new("TextButton")
local CounterVariable = PlayerTableLoad["Counter"] or 0
Button.BorderSizePixel = 0
Button.TextSize = 24
Button.TextScaled = true
Button.AnchorPoint = Vector2.new(0.5,0.5)
Button.Position = UDim2.new(0.5,0,0.5,0)
Button.Size = UDim2.new(0.3,0,0.1,0)
Button.SizeConstraint = Enum.SizeConstraint.RelativeXY
Button.Text = "Click!"
Button.Parent = testWidget

local Label = Instance.new("TextLabel")
Label.AnchorPoint = Vector2.new(0.5,0.5)
Label.Position = UDim2.new(0.5,0,-0.7,0)
Label.TextSize = 24
Label.BackgroundTransparency = 1
Label.Font = Enum.Font.GothamBlack
Label.BorderSizePixel = 0
Label.Size = UDim2.new(1,0,1,0)
Label.SizeConstraint = Enum.SizeConstraint.RelativeXY
updateObjectTest(Label, "Counter: "..CounterVariable)
Label.Parent = Button

local ClicksPerSecond = PlayerTableLoad["ClicksPerSecond"] or 0
local CPSText = Instance.new("TextLabel")
CPSText.AnchorPoint = Vector2.new(0.5,0.5)
CPSText.Position = UDim2.new(0.5,0,-0.7,0)
CPSText.Parent = Label
CPSText.TextScaled = true
CPSText.TextSize = 16
CPSText.SizeConstraint = Enum.SizeConstraint.RelativeXY
CPSText.BorderSizePixel = 0
CPSText.BackgroundTransparency = 1
CPSText.Size = UDim2.new(1,0,1,0)
CPSText.Text = "Clicks per Second: "..ClicksPerSecond

local Title = Instance.new("TextLabel")
Title.AnchorPoint = Vector2.new(0.5,0.5)
Title.Position = UDim2.new(0.5,0,0.1,0)
Title.SizeConstraint = Enum.SizeConstraint.RelativeXY
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.Font = Enum.Font.GothamBold
Title.Size = UDim2.new(0.5, 0, 0, 50)
Title.Text = testWidget.Title
Title.TextSize = 48
Title.Parent = testWidget

local UpgradeFolder = Instance.new("ScrollingFrame")
UpgradeFolder.Parent = Button
UpgradeFolder.Size = UDim2.new(2,0, 0, 100)
UpgradeFolder.SizeConstraint = Enum.SizeConstraint.RelativeXY
UpgradeFolder.AnchorPoint = Vector2.new(0.5,0.5)
UpgradeFolder.BackgroundTransparency = 1
UpgradeFolder.BorderSizePixel = 0
UpgradeFolder.Position = UDim2.new(0.5,0,4,10)

local UIGrid = Instance.new("UIGridLayout")
UIGrid.FillDirectionMaxCells = 2
UIGrid.Parent = UpgradeFolder
UIGrid.FillDirection = Enum.FillDirection.Horizontal
UIGrid.SortOrder = Enum.SortOrder.LayoutOrder
UIGrid.CellPadding = UDim2.new(0,19,0,10)
UIGrid.CellSize = UDim2.new(0.5,-10,0.2,0)

function updateCPS()
	local temporaryVariable = 0
	for name, upgradeTable in pairs(PlayerUpgrades) do
		temporaryVariable = temporaryVariable + (upgradeTable["UpgradeCounter"] * UpgradeDictionary[name]["ClicksPerSecond"])
	end
	ClicksPerSecond = temporaryVariable
	CPSText.Text = "Clicks per Second: "..ClicksPerSecond 
end


local TableCounter = 0
RecalculateCost()

for name, value in pairs(UpgradeDictionary) do
	
	local NewLabel = Instance.new("TextLabel")
	NewLabel.Text = name
	NewLabel.Parent = UpgradeFolder
	NewLabel.BorderSizePixel = 0
	--NewLabel.TextScaled = true
	NewLabel.SizeConstraint = Enum.SizeConstraint.RelativeXY
	NewLabel.BackgroundTransparency = 1
	NewLabel.Font = Enum.Font.Gotham
	NewLabel.TextWrapped = true
	NewLabel.TextSize = 12
	NewLabel.LayoutOrder = TableCounter
	TableCounter = TableCounter + 1
--	print("New label "..NewLabel.Text.." has a layout order of "..NewLabel.LayoutOrder)

	local NewButton = Instance.new("TextButton")
	NewButton.Text = "Buy - "..math.ceil(value["TemporaryPrice"])
	NewButton.Parent = UpgradeFolder
	NewButton.Name = name
	NewButton.TextSize = 8
	--NewButton.TextScaled = true
	NewButton.SizeConstraint = Enum.SizeConstraint.RelativeXY
	NewButton.BorderSizePixel = 0
	NewButton.LayoutOrder = TableCounter
	TableCounter = TableCounter + 1
--	print("New label "..NewButton.Text.." has a layout order of "..NewButton.LayoutOrder)
end
--

Button.MouseButton1Down:Connect(function()
	CounterVariable = CounterVariable + 1
	updateObjectTest(Label, "Counter: "..math.floor(CounterVariable))
end)

for index, button in pairs(UpgradeFolder:GetChildren()) do
	if(button:IsA("TextButton")) then
		button.MouseButton1Down:Connect(function()
			if(CounterVariable >= UpgradeDictionary[button.Name]["TemporaryPrice"]) then 
				CounterVariable = CounterVariable - UpgradeDictionary[button.Name]["TemporaryPrice"] 
				updateObjectTest(Label, "Counter: "..math.floor(CounterVariable)) 
				RecalculateCost()
				updateObjectTest(button, "Buy - "..math.ceil(UpgradeDictionary[button.Name]["TemporaryPrice"])) else return end
			if not PlayerUpgrades[button.Name] then PlayerUpgrades[button.Name] = {["UpgradeCounter"] = 1} else PlayerUpgrades[button.Name]["UpgradeCounter"] = PlayerUpgrades[button.Name]["UpgradeCounter"] + 1 end
			updateCPS()
		end)
	end
end

local TimeOfLastClick, TimeOfLastSave = tick(), tick()

game:GetService("RunService").RenderStepped:Connect(function()
	if (tick() - TimeOfLastClick >= 1) then
--		print("Roughly one second has passed!")
		for UpgradeName, Table in pairs(PlayerUpgrades) do
			CounterVariable = CounterVariable + (Table["UpgradeCounter"]*UpgradeDictionary[UpgradeName]["ClicksPerSecond"])
			updateObjectTest(Label, "Counter: "..math.floor(CounterVariable))
		end
		TimeOfLastClick = tick()
	end
	if(tick() - TimeOfLastSave >= 10) then
		print("10 seconds has passed since the last save file!")
		PlayerTableLoad["Counter"] = CounterVariable
		PlayerTableLoad["ClicksPerSecond"] = ClicksPerSecond
		PlayerTableLoad["PlayerUpgrades"] = PlayerUpgrades
		plugin:SetSetting(Key, PlayerTableLoad)
		TimeOfLastSave = tick()
	end
end)

