unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Arrow, ComCtrls, Spin, LazLogger,
  Tilemap;

type

  { TForm1 }

  TForm1 = class(TForm)
    Arrow1: TArrow;
    Arrow2: TArrow;
    Arrow3: TArrow;
    Arrow4: TArrow;
    Button1: TButton;
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image29: TImage;
    Image3: TImage;
    Image30: TImage;
    Image31: TImage;
    Image32: TImage;
    Image33: TImage;
    Image34: TImage;
    Image35: TImage;
    Image36: TImage;
    Image37: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    PageControl1: TPageControl;
    SpinEdit1: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    procedure Arrow1Click(Sender: TObject);
    procedure Arrow2Click(Sender: TObject);
    procedure Arrow3Click(Sender: TObject);
    procedure Arrow4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure SetUpGui();
begin
  // Ist notwendig da bei verschieden Monitoren sich die Gui-Elemente verschoben haben

  // Start
  Form1.Button1.Visible:=false;

  // Bauen
  Form1.ToggleBox1.Left:=1600;
  Form1.ToggleBox1.Top:=364;
  Form1.ToggleBox1.Height:=64;
  Form1.ToggleBox1.Width:=64;
  Form1.ToggleBox1.Visible:=true;

  // Abreisen
  Form1.ToggleBox2.Left:=1664;
  Form1.ToggleBox2.Top:=364;
  Form1.ToggleBox2.Height:=64;
  Form1.ToggleBox2.Width:=64;
  Form1.ToggleBox2.Visible:=true;

  // Navigations-Pfeile

     // Westen
     Form1.Arrow1.Left:=1568;
     Form1.Arrow1.Top:=Round(mapHeight/2)+16;
     Form1.Arrow1.Height:=32;
     Form1.Arrow1.Width:=32;

     // Norden
     Form1.Arrow2.Left:=1568+Round(mapWidth/2)+16;
     Form1.Arrow2.Top:=0;
     Form1.Arrow2.Height:=32;
     Form1.Arrow2.Width:=32;

     // Osten
     Form1.Arrow4.Left:=1568+mapWidth+32;
     Form1.Arrow4.Top:=Round(mapHeight/2)+16;
     Form1.Arrow4.Height:=32;
     Form1.Arrow4.Width:=32;

     // Süden
     Form1.Arrow3.Left:=1568+Round(mapWidth/2)+16;
     Form1.Arrow3.Top:=mapHeight+32;
     Form1.Arrow3.Height:=32;
     Form1.Arrow3.Width:=32;

  // BauMenu
  Form1.PageControl1.Left:=1600;
  Form1.PageControl1.Top:=428;
  Form1.PageControl1.Height:=400;
  Form1.PageControl1.Height:=320;

  // Tile Select (Temperär)
  Form1.SpinEdit1.Left:=1728;
  Form1.SpinEdit1.Top:=364;
  Form1.SpinEdit1.Height:=64;
  Form1.SpinEdit1.Width:=128;
  Form1.SpinEdit1.MaxValue:=15;
  Form1.SpinEdit1.MinValue:=3;
end;

procedure DrawMinimap();
var x, y : Integer;
  bmp: TBitmap;
begin
  // Die Minimap wird Pixel für Pixel neu, anhand der Gebäudefarbe ertstellt

  bmp:=TBitmap.Create;
  bmp.Height:=mapHeight;
  bmp.Width:=mapWidth;
  for x:=0 to mapWidth-1 do
  begin
    for y:=0 to mapHeight-1 do
    begin
      if buildings[x][y].id<3 then
        bmp.Canvas.Pixels[x, y]:=GetMinimapColor(terrain[x][y])
      else
        bmp.Canvas.Pixels[x, y]:=GetMinimapColor(buildings[x][y].id)
    end;
  end;
  Form1.Canvas.Draw(32*screenWidth+32, 32, bmp);


  // Der Sichtbare bereich wird durch umrandung kenntlich gemacht
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+32, (offsetX+32*screenWidth)+32, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+screenWidth+32, offsetY+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
  Form1.Canvas.Line((offsetX+32*screenWidth)+32, offsetY+screenHeight+32, (32+offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight+32);
end;

procedure UpdateMinimapTile(tileX, tileY : Integer);
var x, y : Integer;
  bmp: TBitmap;
begin
  // Die Minimap wird Pixel für Pixel neu, anhand der Gebäudefarbe ertstellt

  bmp:=TBitmap.Create;
  bmp.Height:=mapHeight;
  bmp.Width:=mapWidth;
  for x:=tileX-1 to tileX+1 do
  begin
    for y:=tileY-1 to tileY+1 do
    begin

      // Falls nach einer Koordinate außerhalb des Arrays gefragt wird
      if (x>=0) or (x<=screenWidth-1) or (y>=0) or (y<=screenHeight-1)then
      begin
        if (buildings[x][y].id<3) then
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(terrain[x][y])
        else
          Form1.Canvas.Pixels[32*screenWidth+x+32, y+32]:=GetMinimapColor(buildings[x][y].id)
      end;
    end;
  end;
end;

procedure DrawMap();
var x, y : Integer;
    bmp: TBitmap;
begin
  // Initialisieren einer neuen Bitmap
  // Diese wird benutzt um die Tiles auf die Form zu malen
  bmp:=TBitmap.Create;
  bmp.Height:=screenHeight*32;
  bmp.Width:=screenWidth*32;

  // Jedes Sichtbare Tile wird gesammtelt und zu einem Bild zusammengesetzt
  for x:=0 to screenWidth-1 do
  begin
    for y:=0 to screenHeight-1 do
    begin
      bmp.Canvas.Draw(x*32, y*32, Tilemap.GetTileBitmap(x+offsetX, y+offsetY));
    end;
  end;

  // Die Tiles werden auf das Form gemalt
  Form1.Canvas.Draw(0, 0, bmp);
  DrawMinimap();
end;

procedure UpdateTilemapTile(tileX, tileY, radius : Integer);
var x, y, screenX, screenY : Integer;
begin
  screenX:=tileX-offsetX;
  screenY:=tileY-offsetY;
  // Initialisieren einer neuen Bitmap
  // Diese wird benutzt um die Tiles auf die Form zu malen

  // Jedes Sichtbare Tile wird gesammtelt und zu einem Bild zusammengesetzt
  for x:=screenX-radius to screenX+radius do
  begin
    for y:=screenY-radius to screenY+radius do
    begin
      // schließt aus das außerhalb der Arrays abgefragt wird
      if (x>=0) and (x<=screenWidth-1) and (y>=0) and (y<=screenHeight-1)then
        begin
          Form1.Canvas.Draw(x*32, y*32, Tilemap.GetTileBitmap(x+offsetX, y+offsetY));
        end;
    end;
  end;

  // Die Tiles werden auf das Form gemalt
  UpdateMinimapTile(tileX, tileY);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

end;

procedure MoveCamera(x, y: Integer);
begin

  // Ver#ndern der Kameraposition durch setzten der Offsets
  offsetX:=x;
  offsetY:=y;

  // Kamera darf nicht über sichtbaren Bereich hinaus
  // X
  if offsetX<0 then
     offsetX:=0;
  if offsetX>mapWidth-screenWidth-1 then
     offsetX:=mapWidth-screenWidth-1;

  // Y
  if offsetY<0 then
     offsetY:=0;
  if offsetY>mapHeight-screenHeight then
     offsetY:=mapHeight-screenHeight;

  DrawMap();
end;

procedure PlaceTerrainTile(x, y, id : Integer);
begin
  terrain[x][y]:=id;

  UpdateTilemapTile(x, y, 5);
end;

procedure TForm1.FormClick(Sender: TObject);
var tilePos, mousePos:TPoint;
begin
  mousePos:=Form1.ScreenToClient(TPoint.Create(Mouse.CursorPos.X, Mouse.CursorPos.Y));

  // Klick in Tilemap
  if (mousePos.X < (screenWidth*32)) and (mousePos.Y<(screenHeight*32)) then
     begin
       TilePos:=Tilemap.FormCoordsToTile(mousePos.X+(offsetX*32), mousePos.Y+(offsetY*32));

       // Build Tile
       if Form1.ToggleBox1.Checked then
         begin
           PlaceBuildingTile(tilePos.X, tilePos.Y, Form1.SpinEdit1.Value);
           UpdateTilemapTile(tilePos.x, tilepos.y, 5);
         end


       // Destroy Tile
       else if Form1.ToggleBox2.Checked then
         begin
           DestroyBuildingTile(tilepos.x, tilepos.Y);
           UpdateTilemapTile(tilePos.x, tilepos.y, 2);
         end

       // Click Tile
       else
         //DebugTile(TilePos.X, TilePos.Y);

       //DrawMap();
     end;

  // Klick in Minimap
  if (mousePos.X > ((screenWidth*32)+32)) and (mousePos.Y < mapHeight+32) then
      MoveCamera((mousePos.X-(screenWidth*32)-Round(screenWidth/2))-32, (mousePos.Y-Round(screenHeight/2))-32);

end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  SpinEdit1.Value:=7;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  SpinEdit1.Value:=9;
end;

procedure TForm1.Arrow2Click(Sender: TObject);
begin
  MoveCamera(offsetX, offsetY-1);
end;

procedure TForm1.Arrow3Click(Sender: TObject);
begin
  MoveCamera(offsetX, offsetY+1);
end;

procedure TForm1.Arrow4Click(Sender: TObject);
begin
  MoveCamera(offsetX+1, offsetY);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Start des Programms
  SetUpGui();
  GenerateMap();
  DrawMap();
  DrawMinimap();
end;

procedure TForm1.Arrow1Click(Sender: TObject);
begin
  MoveCamera(offsetX-1, offsetY);
end;
initialization
begin
  // Wird bei Programmstart ausgeführt
  GenerateMap();
end;
end.


