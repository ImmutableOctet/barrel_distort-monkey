Strict

Public

' Preprocessor related:
#GLFW_WINDOW_TITLE = "Barrel Distortion Demo"
#GLFW_WINDOW_WIDTH = 640
#GLFW_WINDOW_HEIGHT = 480

#GLFW_WINDOW_RESIZABLE = True

'#GLFW_SWAP_INTERVAL=-1

#MOJO_AUTO_SUSPEND_ENABLED = False

' Imports:
Import mojo2

' Classes:
Class BarrelShader Extends BumpShader ' Final
	' Global variable(s) (Private):
	Private
	
	Global _Instance:BarrelShader
	
	Public
	
	' Functions:
	Function Instance:BarrelShader()
		If (_Instance = Null) Then
			_Instance = New BarrelShader()
		Endif
		
		Return _Instance
	End
	
	' Constructor(s):
	Method New()
		Build(LoadString("monkey://data/barrel_distort.glsl"))
	End
	
	' Methods:
	Method OnInitMaterial:Void(M:Material)
		Super.OnInitMaterial(M)
		
		M.SetScalar("EffectPower", 1.0)
		
		Return
	End
End

Class Application Extends App Final
	' Constructor(s):
	Method OnCreate:Int()
		SetUpdateRate(60)
		
		Graphics = New Canvas()
		
		Local Barrel:= BarrelShader.Instance()
		
		'Shader.SetDefaultShader(Barrel)
		
		Local T:= New Texture(480, 480, 4, Texture.ClampST|Texture.RenderTarget)
		
		Local M:= New Material(Barrel)
		
		M.SetTexture("ColorTexture", T)
		
		TestImage = New Image(M)
		
		TestCanvas = New Canvas(TestImage)
		
		' Return the default response.
		Return 0
	End
	
	' Methods:
	Method OnUpdate:Int()
		If (KeyDown(KEY_UP)) Then
			EffectPower += 0.01
		Endif
		
		If (KeyDown(KEY_DOWN)) Then
			EffectPower -= 0.01
		Endif
		
		' Return the default response.
		Return 0
	End
	
	Method OnRender:Int()
		Graphics.SetViewport(0, 0, DeviceWidth(), DeviceHeight())
		Graphics.SetProjection2d(0, DeviceWidth(), 0, DeviceHeight())
		
		Graphics.Clear(0.2, 0.2, 0.2)
		
		DrawTest()
		
		Graphics.Flush()
		
		' Return the default response.
		Return 0
	End
	
	Method DrawTest:Void()
		TestCanvas.Clear()
		
		TestImage.Material.SetScalar("EffectPower", EffectPower)
		
		DrawGrid(TestCanvas, 8, 8)
		
		TestCanvas.Flush()
		
		Graphics.DrawImage(TestImage, Float(DeviceWidth() / 2), Float(DeviceHeight() / 2))
		
		Return
	End
	
	Method DrawGrid:Void(Graphics:DrawList, TileMapWidth:Int, TileMapHeight:Int, X:Float=0.0, Y:Float=0.0)
		Local MapWidth:= (TestImage.Width / Float(TileMapWidth))
		Local MapHeight:= (TestImage.Height / Float(TileMapHeight))
		
		Local TileWidth:= MapWidth ' 64.0 ' 32.0
		Local TileHeight:= MapHeight ' 64.0 ' 32.0
		
		Graphics.PushMatrix()
		
		Graphics.Translate(X, Y)
		
		For Local Y:= 0 Until MapHeight
			For Local X:= 0 Until MapWidth
				Local XPos:Float = Float(X*TileWidth)
				Local YPos:Float = Float(Y*TileHeight)
				
				If (((X+Y) Mod 2) = 0) Then
					Graphics.SetColor(0.5, 0.0, 0.0)
				Else
					Graphics.SetColor(0.7, 0.7, 0.7)
				Endif
				
				Graphics.DrawRect(XPos, YPos, TileWidth, TileHeight)
			Next
		Next
		
		Graphics.PopMatrix()
		
		Return
	End
	
	' Fields:
	Field Graphics:Canvas
	
	Field TestCanvas:Canvas
	Field TestImage:Image
	
	Field EffectPower:Float = 1.0
End

' Functions:
Function Main:Int()
	New Application()
	
	' Return the default response.
	Return 0
End