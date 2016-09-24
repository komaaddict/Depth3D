 ////----------------//
 ///**SuperDepth3D**///
 //----------------////

 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 //* Depth Map Based 3D post-process shader v1.8.8 L & R Eye																														*//
 //* For Reshade 3.0																																								*//
 //* --------------------------																																						*//
 //* This work is licensed under a Creative Commons Attribution 3.0 Unported License.																								*//
 //* So you are free to share, modify and adapt it for your needs, and even use it for commercial use.																				*//
 //* I would also love to hear about a project you are using it with.																												*//
 //* https://creativecommons.org/licenses/by/3.0/us/																																*//
 //*																																												*//
 //* Have fun,																																										*//
 //* Jose Negrete AKA BlueSkyDefender																																				*//
 //*																																												*//
 //* http://reshade.me/forum/shader-presentation/2128-sidebyside-3d-depth-map-based-stereoscopic-shader																				*//	
 //* ---------------------------------																																				*//
 //*																																												*//
 //* Original work was based on Shader Based on CryTech 3 Dev work http://www.slideshare.net/TiagoAlexSousa/secrets-of-cryengine-3-graphics-technology								*//
 //*																																												*//
 //* 																																												*//
 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Change the Cross Cusor Key
// Determines the Cusor Toggle Key useing keycode info
// You can use http://keycode.info/ to figure out what key is what.
// key B is Key Code 66, This is Default. Ex. Key 187 is the code for Equal Sign =.

#define Cross_Cusor_Key 66

uniform int Alternet_Depth_Map <
	ui_type = "combo";
	ui_items = "Depth Map 0\0Depth Map 1\0";
	ui_label = "Alternate Depth Map";
	ui_tooltip = "Alternate Depth Map for different Games. Read the ReadMeDepth3d.txt, for setting. Each game May and can use a diffrent Alternet Depth Map.";
> = 0;

uniform int Depth <
	ui_type = "drag";
	ui_min = 0; ui_max = 30;
	ui_label = "Depth Slider";
	ui_tooltip = "Determines the amount of Image Warping and Separation between both eyes.";
> = 10;

uniform float Adjust <
	ui_type = "drag";
	ui_min = 0; ui_max = 10;
	ui_label = "Adjust";
	ui_tooltip = "Adjust Near Far";
> = 0.0;

uniform int Perspective <
	ui_type = "drag";
	ui_min = -100; ui_max = 100;
	ui_label = "Perspective Slider";
	ui_tooltip = "Determines the perspective point.";
> = 0;

uniform float Blur <
	ui_type = "drag";
	ui_min = 0; ui_max = 0.5;
	ui_label = "Blur Slider";
	ui_tooltip = "Determines the blur seperation of Depth Map Blur.";
> = 0.050;

uniform bool Depth_Map_Flip <
	ui_label = "Depth Map Flip";
	ui_tooltip = "Depth Flip if the depth map is Upside Down.";
> = false;

uniform bool Depth_Map_View <
	ui_label = "Depth Map View";
	ui_tooltip = "Display the Depth Map. Use This to Work on your Own Depth Map for your game.";
> = false;

uniform int Custom_Depth_Map <
	ui_type = "combo";
	ui_items = "Custom Off\0Custom One\0Custom Two\0Custom Three\0Custom Four\0Custom Five\0Custom Six\0Custom Seven\0Custom Eight\0";
	ui_label = "Custom Depth Map";
	ui_tooltip = "Adjust your own Custom Depth Map.";
> = 0;

uniform float Far <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "Far";
	ui_tooltip = "Far Depth Map Adjustment.";
> = 1.5;
 
 uniform float Near <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "Near";
	ui_tooltip = "Near Depth Map Adjustment.";
> = 1;

uniform float DFar <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "DFar";
	ui_tooltip = "Far Depth Map Adjustment.";
> = 1.5;
 
 uniform float DNear <
	ui_type = "drag";
	ui_min = 0; ui_max = 5;
	ui_label = "DNear";
	ui_tooltip = "Near Depth Map Adjustment.";
> = 1;

uniform int Polynomial_Barrel_Distortion <
	ui_type = "combo";
	ui_items = "Off\0Polynomial Distortion\0";
	ui_label = "Polynomial Barrel Distortion";
	ui_tooltip = "Barrel Distortion for HMD type Displays.";
> = 0;

uniform float3 Polynomial_Colors <
	ui_type = "color";
	ui_tooltip = "Adjust the Polynomial Distortion Red, Green, Blue. Default is (R 255, G 255, B 255)";
	ui_label = "Polynomial Color Distortion";
> = float3(1.0, 1.0, 1.0);

uniform float Horizontal_Squish <
	ui_type = "drag";
	ui_min = 0.5; ui_max = 2;
	ui_label = "Horizontal Squish";
	ui_tooltip = "Horizontal squish cubic distortion value. Default is 1.0.";
> = 1.00;

uniform float Vertical_Squish <
	ui_type = "drag";
	ui_min = 0.5; ui_max = 2;
	ui_label = "Vertical Squish";
	ui_tooltip = "Vertical squish cubic distortion value. Default is 1.0.";
> = 1.0;

uniform int Stereoscopic_Mode <
	ui_type = "combo";
	ui_items = "Side by Side\0Top and Bottom\0Line Interlaced\0Checkerboard 3D\0";
	ui_label = "3D Display Mode";
	ui_tooltip = "Side by Side/Top and Bottom/Line Interlaced displays output.";
> = 0;

uniform int Custom_Sidebars <
	ui_type = "combo";
	ui_items = "Mirrored Edges\0Black Edges\0Stretched Edges\0";
	ui_label = "Edge Selection";
	ui_tooltip = "Select how you like the Edge of the screen to look like.";
> = 1;

uniform float Cross_Cusor_Size <
	ui_type = "drag";
	ui_min = 1; ui_max = 100;
	ui_tooltip = "Pick your size of the cross cusor.";
	ui_label = "Cross Cusor Size";
> = 20.0;

uniform float3 Cross_Cusor_Color <
	ui_type = "color";
	ui_tooltip = "Pick your own cross cusor color.";
	ui_label = "Cross Cusor Color";
> = float3(1.0, 1.0, 1.0);

uniform bool Eye_Swap <
	ui_label = "Eye Swap";
	ui_tooltip = "Left right image change.";
> = false;

uniform bool mouse < source = "key"; keycode = Cross_Cusor_Key; toggle = true; >;

uniform float2 Mousecoords < source = "mousepoint"; > ;

/////////////////////////////////////////////D3D Starts Here/////////////////////////////////////////////////////////////////

#define pix float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT)

texture DepthBufferTex : DEPTH;

sampler DepthBuffer 
	{ 
		Texture = DepthBufferTex; 
	};

texture BackBufferTex : COLOR;

sampler BackBuffer 
	{ 
		Texture = BackBufferTex;
	};

sampler BackBufferMIRROR 
	{ 
		Texture = BackBufferTex;
		AddressU = MIRROR;
		AddressV = MIRROR;
		AddressW = MIRROR;
	};

sampler BackBufferBORDER
	{ 
		Texture = BackBufferTex;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};

sampler BackBufferCLAMP
	{ 
		Texture = BackBufferTex;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
texture texCL  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCR  { Width = BUFFER_WIDTH; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCC  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT; Format = RGBA32F;}; 
texture texCDM  { Width = BUFFER_WIDTH/2; Height = BUFFER_HEIGHT; Format = RGBA32F;};

sampler SamplerCL
	{
		Texture = texCL;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};
	
sampler SamplerCR
	{
		Texture = texCR;
		AddressU = BORDER;
		AddressV = BORDER;
		AddressW = BORDER;
	};
	
sampler SamplerCC
	{
		Texture = texCC;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
sampler SamplerCDM
	{
		Texture = texCDM;
		AddressU = CLAMP;
		AddressV = CLAMP;
		AddressW = CLAMP;
	};
	
float4 MouseCuror(float4 pos : SV_Position, float2 texcoord : TEXCOORD) : SV_Target
{
	float4 Mpointer; 
	if(mouse)
	{
	Mpointer = all(abs(Mousecoords - pos.xy) < Cross_Cusor_Size) * (1 - all(abs(Mousecoords - pos.xy) > Cross_Cusor_Size/(Cross_Cusor_Size/2))) ? float4(Cross_Cusor_Color, 1.0) : tex2D(BackBuffer, texcoord);//cross
	}
	else
	{
	Mpointer =  tex2D(BackBuffer, texcoord);
	}
	return Mpointer;
}

//Depth Map Information	
float4 SbSdepth(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{

	 float4 color = 0;

			if (Depth_Map_Flip)
			texcoord.y =  1 - texcoord.y;
	
	float4 depthM = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
	float4 depthMFar = tex2D(DepthBuffer, float2(texcoord.x, texcoord.y));
		
		if (Custom_Depth_Map == 0)
	{	
		//Alien Isolation | Fallout 4 | Firewatch
		if (Alternet_Depth_Map == 0)
		{
		float cF = 1000000000;
		float cN = 1;	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}

		//Batman Arkham Knight | Batman Arkham Origins | Batman: Arkham City | BorderLands 2 | Hard Reset | Lords Of The Fallen | The Elder Scrolls V: Skyrim
		if (Alternet_Depth_Map == 1)
		{
		float cF = 50;
		float cN = 0;
		depthM = (pow(abs(cN-depthM),cF));
		}	
	}
	else
	{
		//Custom One
		if (Custom_Depth_Map == 1)
		{
		float cF = Far; //10+
		float cN = Near;//1
		depthM = (pow(abs(cN-depthM),cF));
		}
		
		//Custom Two
		if (Custom_Depth_Map == 2)
		{
		float cF  = Far; //100+
		float cN = Near; //0.01-
		depthM = cF / (1 + cF - (depthM/cN) * (1 - cF));
		}
		
		//Custom Three
		if (Custom_Depth_Map == 3)
		{
		float cF  = Far;//0.025
		float cN = Near;//1.0
		depthM =  (cN * cF / (cF + depthM * (cN - cF))); 
		}
		
		//Custom Four
		if (Custom_Depth_Map == 4)
		{
		float cF = Far;//1000000000 or 1	
		float cN = Near;//0 or 13	
		depthM = (exp(depthM * log(cF + cN)) - cN) / cF;
		}
		
		//Custom Five
		if (Custom_Depth_Map == 5)
		{
		float cF = Far;//1
		float cN = Near;//0.025
		depthM = cN/(cN-cF) / ( depthM - cF/(cF-cN));
		}
		
		//Custom Six
		if (Custom_Depth_Map == 6)
		{
		float cF = Far;//1
		float cN = Near;//1.875
		depthM = clamp(1 - (depthM * cF / (cF - cN) + cN) / depthM,0,255); //Infinite reversed-Z. Clamped, not so Infinate anymore.
		}
		
		//Custom Seven
		if (Custom_Depth_Map == 7)
		{
		float cF = Far;//1
		float cN = Near;//1.875
		depthM = clamp(1 - ((depthM * (cF + cN) / (cF - cN) + (2*cN)) / depthM),0,255); //GL-style Infinite reversed-Z. Clamped, not so Infinate anymore.
		}
		
		//Custom Eight
		if (Custom_Depth_Map == 8)
		{
		float cF = Far;//1.010+	
		float cN = Near;//0	
		depthM = pow(abs((exp(depthM * log(cF + cN)) - cN) / cF),1000);
		}
		
	}

    float Adj;
    float4 D;
	
		
		if (Alternet_Depth_Map == 1)
		{
		float cDF = 1.025;
		float cDN = 0;
		depthMFar = pow(abs((exp(depthM * log(cDF + cDN)) - cDN) / cDF),1000);
		}

	
    D = lerp(depthMFar,depthM,0.75);

		color.rgb = D.rrr;
		
	return color;	
}
	
float4 BlurDM(float4 pos : SV_Position, float2 texcoord : TEXCOORD0) : SV_Target
{
	float4 color;
	float Con = 11;
		
	if(Blur > 0)
	{
	const float weight[10] = 
	{  
	-0.08,  
	-0.05,  
	-0.03,  
	-0.02,  
	-0.01,  
	0.01,  
	0.02,  
	0.03,  
	0.05,  
	0.08  
	};  
	
	float2 dir = float2(0.5,0);
	dir = normalize( dir );  
	[loop]
	for (int i = -0; i < 10; i++)
	{
	color += tex2D(SamplerCDM,texcoord + dir * weight[i] * Blur)/Con;  
	}
	}
	else
	{
	color = tex2D(SamplerCDM,texcoord.xy);
	}
	return color;
} 
  
////////////////////////////////////////////////Left/Right Eye////////////////////////////////////////////////////////
void PS_renderLR(in float4 position : SV_Position, in float2 texcoord : TEXCOORD0, out float4 color : SV_Target0 , out float4 colorT: SV_Target1)
{	
	const float samples[4] = {0.45, 0.666, 1, 0.25};
	float DepthL = 1.0, DepthR = 1.0;
	float2 uv = 0;
	[loop]
	for (int j = 0; j <= 3; ++j) 
	{	
			uv.x = samples[j] * Depth;
			DepthL =  min(DepthL,tex2D(SamplerCC,float2(texcoord.x+uv.x*pix.x, texcoord.y)).r);
			DepthR =  min(DepthR,tex2D(SamplerCC,float2(texcoord.x-uv.x*pix.x, texcoord.y)).r);
	}
			
		if(!Eye_Swap)
		{	
			if(Custom_Sidebars == 0)
			{
			color = tex2D(BackBufferMIRROR, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			colorT = tex2D(BackBufferMIRROR, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
			else if(Custom_Sidebars == 1)
			{
			color = tex2D(BackBufferBORDER, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			colorT = tex2D(BackBufferBORDER, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
			else
			{
			color = tex2D(BackBufferCLAMP, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			colorT = tex2D(BackBufferCLAMP, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
		}
		else
		{		
			if(Custom_Sidebars == 0)
			{
			colorT = tex2D(BackBufferMIRROR, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			color = tex2D(BackBufferMIRROR, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
			else if(Custom_Sidebars == 1)
			{
			colorT = tex2D(BackBufferBORDER, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			color = tex2D(BackBufferBORDER, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
			else
			{
			colorT = tex2D(BackBufferCLAMP, float2(texcoord.xy+float2(DepthL*Depth,0)*pix.xy));
			color = tex2D(BackBufferCLAMP, float2(texcoord.xy-float2(DepthR*Depth,0)*pix.xy));
			}
		}
}


////////////////////////////////////////////////////Polynomial_Distortion/////////////////////////////////////////////////////

float2 PD(float2 p, float k1)

{

	
	float r2 = (p.x-0.5) * (p.x-0.5) + (p.y-0.5) * (p.y-0.5);       
	float newRadius = 0.0;

	newRadius = (1 + k1*r2);

	 p.x = newRadius * (p.x-0.5)+0.5;
	 p.y = newRadius * (p.y-0.5)+0.5;
	
	return p;
}

float4 PDL(float2 texcoord)

{		
		float4 color;
		float2 uv_red, uv_green, uv_blue;
		float4 color_red, color_green, color_blue;
		float Red, Green, Blue;
		float2 sectorOrigin;

    // Radial distort around center
		sectorOrigin = (texcoord.xy-0.5,0,0);
		
		Red = Polynomial_Colors.x;
		Green = Polynomial_Colors.y;
		Blue = Polynomial_Colors.z;
		
		uv_red = PD(texcoord.xy-sectorOrigin,Red) + sectorOrigin;
		uv_green = PD(texcoord.xy-sectorOrigin,Green) + sectorOrigin;
		uv_blue = PD(texcoord.xy-sectorOrigin,Blue) + sectorOrigin;

		color_red = tex2D(SamplerCL, uv_red).r;
		color_green = tex2D(SamplerCL, uv_green).g;
		color_blue = tex2D(SamplerCL, uv_blue).b;


		if( ((uv_red.x > 0) && (uv_red.x < 1) && (uv_red.y > 0) && (uv_red.y < 1)))
		{
			color = float4(color_red.x, color_green.y, color_blue.z, 1.0);
		}
		else
		{
			color = float4(0,0,0,1);
		}
		return color;
		
	}
	
	float4 PDR(float2 texcoord)

{		
		float4 color;
		float2 uv_red, uv_green, uv_blue;
		float4 color_red, color_green, color_blue;
		float Red, Green, Blue;
		float2 sectorOrigin;

    // Radial distort around center
		sectorOrigin = (texcoord.xy-0.5,0,0);
		
		Red = Polynomial_Colors.x;
		Green = Polynomial_Colors.y;
		Blue = Polynomial_Colors.z;
		
		uv_red = PD(texcoord.xy-sectorOrigin,Red) + sectorOrigin;
		uv_green = PD(texcoord.xy-sectorOrigin,Green) + sectorOrigin;
		uv_blue = PD(texcoord.xy-sectorOrigin,Blue) + sectorOrigin;

		color_red = tex2D(SamplerCR, uv_red).r;
		color_green = tex2D(SamplerCR, uv_green).g;
		color_blue = tex2D(SamplerCR, uv_blue).b;


		if( ((uv_red.x > 0) && (uv_red.x < 1) && (uv_red.y > 0) && (uv_red.y < 1)))
		{
			color = float4(color_red.x, color_green.y, color_blue.z, 1.0);
		}
		else
		{
			color = float4(0,0,0,1);
		}
		return color;
		
	}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void PS0(float4 position : SV_Position, float2 texcoord : TEXCOORD0, out float4 color : SV_Target)
{
	if(!Depth_Map_View)
	{
	if(Stereoscopic_Mode == 0)
	{
	float posH = Horizontal_Squish-1;
	float midH = posH*BUFFER_HEIGHT/2*pix.y;
	
	float posV = Vertical_Squish-1;
	float midV = posV*BUFFER_WIDTH/2*pix.x;
	
		if(Polynomial_Barrel_Distortion == 0)
		{
		color = texcoord.x < 0.5 ? tex2D(SamplerCL,float2(texcoord.x*2 + Perspective * pix.x,texcoord.y)) : tex2D(SamplerCR,float2(texcoord.x*2-1 - Perspective * pix.x,texcoord.y)) ;
		}
		else
		{
		color = texcoord.x < 0.5 ? PDL(float2(((texcoord.x*2)*Vertical_Squish)-midV + Perspective * pix.x,(texcoord.y*Horizontal_Squish)-midH)) : PDR(float2(((texcoord.x*2-1)*Vertical_Squish)-midV - Perspective * pix.x,(texcoord.y*Horizontal_Squish)-midH));
		}
	
	}
	else if(Stereoscopic_Mode == 1)
	{
		color = texcoord.y < 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y*2)) : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y*2-1));
	}
	else if(Stereoscopic_Mode == 2)
	{
		float gridL = frac(texcoord.y*(BUFFER_HEIGHT/2));
		
		color = gridL > 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y)) : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y));
	}
	else
	{
		float gridy = floor(texcoord.y*(BUFFER_HEIGHT));
		float gridx = floor(texcoord.x*(BUFFER_WIDTH));

		color = (int(gridy+gridx) & 1) < 0.5 ? tex2D(SamplerCL,float2(texcoord.x + Perspective * pix.x,texcoord.y)) : tex2D(SamplerCR,float2(texcoord.x - Perspective * pix.x,texcoord.y));
	}
	}
	else
	{
		color = tex2D(SamplerCDM,texcoord.xy);
	}
}


///////////////////////////////////////////////////////////ReShade.fxh/////////////////////////////////////////////////////////////

// Vertex shader generating a triangle covering the entire screen
void PostProcessVS(in uint id : SV_VertexID, out float4 position : SV_Position, out float2 texcoord : TEXCOORD)
{
	texcoord.x = (id == 2) ? 2.0 : 0.0;
	texcoord.y = (id == 1) ? 2.0 : 0.0;
	position = float4(texcoord * float2(2.0, -2.0) + float2(-1.0, 1.0), 0.0, 1.0);
}

///////////////////////////////////////////////Depth Map View//////////////////////////////////////////////////////////////////////

//*Rendering passes*//

technique Super_Depth3D
{			
			pass MousePass
		{
			VertexShader = PostProcessVS;
			PixelShader = MouseCuror;
		}
			pass DepthMapPass
		{
			VertexShader = PostProcessVS;
			PixelShader = SbSdepth;
			RenderTarget = texCDM;
		}
			pass BlurPass
		{
			VertexShader = PostProcessVS;
			PixelShader = BlurDM;
			RenderTarget = texCC;
		}
			pass SinglePassStereo
		{
			VertexShader = PostProcessVS;
			PixelShader = PS_renderLR;
			RenderTarget0 = texCL;
			RenderTarget1 = texCR;
		}
			pass SidebySideTopandBottomLineCheckerboardPass
		{
			VertexShader = PostProcessVS;
			PixelShader = PS0;	
		}
}
