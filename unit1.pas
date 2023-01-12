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
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    ToggleBox1: TToggleBox;
    ToggleBox2: TToggleBox;
    procedure Arrow1Click(Sender: TObject);
    procedure Arrow2Click(Sender: TObject);
    procedure Arrow3Click(Sender: TObject);
    procedure Arrow4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
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
  // Ist notwendig da bei verschieden Monitoren sich die Gui elemente verschoben haben

  // Start
  Form1.Button1.Visible:=false;

  // Bauen
  Form1.ToggleBox1.Left:=1600;
  Form1.ToggleBox1.Top:=300;
  Form1.ToggleBox1.Height:=64;
  Form1.ToggleBox1.Width:=64;
  Form1.ToggleBox1.Visible:=true;

  // Abreisen
  Form1.ToggleBox2.Left:=1664;
  Form1.ToggleBox2.Top:=300;
  Form1.ToggleBox2.Height:=64;
  Form1.ToggleBox2.Width:=64;
  Form1.ToggleBox2.Visible:=true;

  // Debug Memo
  Form1.Memo1.Left:=1600;
  Form1.Memo1.Top:=364;
  Form1.Memo1.Height:=256;
  Form1.Memo1.Width:=300;
  Form1.Memo1.Visible:=true;

  // Tile Select (Temperär)
  Form1.SpinEdit1.Left:=1728;
  Form1.SpinEdit1.Top:=300;
  Form1.SpinEdit1.Height:=64;
  Form1.SpinEdit1.Width:=128;
  Form1.SpinEdit1.MaxValue:=8;
  Form1.SpinEdit1.MinValue:=3;
end;

procedure DebugTile(x, y : Integer);
begin
  // Zeigt alle Warte für ein bestimmtes Gebäude an

  Form1.Memo1.Lines.Clear;
  // ID
  Form1.Memo1.Lines.Add('Id:'#9#9+IntToStr(buildings[x][y].id));
  // Happiness
  Form1.Memo1.Lines.Add('Happiness:'#9+IntToStr(buildings[x][y].happiness));
  // Health
  Form1.Memo1.Lines.Add('Health:'#9#9+IntToStr(buildings[x][y].health));
  // Burning
  Form1.Memo1.Lines.Add('Burning:'#9#9+BoolToStr(buildings[x][y].isOnFire));
  // Level
  Form1.Memo1.Lines.Add('Level:'#9#9+IntToStr(buildings[x][y].level));
  // MaxResidents
  Form1.Memo1.Lines.Add('MaxResidents:'#9+IntToStr(buildings[x][y].maxResidents));
  // Residents
  Form1.Memo1.Lines.Add('Residents:'#9#9+IntToStr(buildings[x][y].residents));
  // IsParentTile
  Form1.Memo1.Lines.Add('IsParentTile:'#9+BoolToStr(buildings[x][y].isParentTile));
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
      case terrain[x][y] of
          0:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(0, 153, 219);
          1:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(62, 137, 72);
          2:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(184, 111, 80);
      end;
      case buildings[x][y].id of
          3:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(38, 43, 68);
          4:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(200, 20, 20);
          6:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(100, 100, 100);
          7:
            bmp.Canvas.Pixels[x, y]:=RGBToColor(0, 0, 255);
      end;
    end;
  end;
  Form1.Canvas.Draw(32*screenWidth, 0, bmp);


  // Der Sichtbare bereich wird durch umrandung kenntlich gemacht
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY, (offsetX+screenWidth)+32*screenWidth, offsetY);
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY, offsetX+32*screenWidth, offsetY+screenHeight);
  Form1.Canvas.Line(offsetX+32*screenWidth+screenWidth, offsetY, (offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight);
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY+screenHeight, (offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight);
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
                case terrain[x][y] of
          0:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(0, 153, 219);
          1:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(62, 137, 72);
          2:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(184, 111, 80);
      end;
      case buildings[x][y].id of
          3:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(38, 43, 68);
          4:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(200, 20, 20);
          6:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(100, 100, 100);
          7:
            Form1.Canvas.Pixels[32*screenWidth+x, y]:=RGBToColor(0, 0, 255);
        end;
      end;
    end;
  end;

  // Der Sichtbare bereich wird durch umrandung kenntlich gemacht
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY, (offsetX+screenWidth)+32*screenWidth, offsetY);
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY, offsetX+32*screenWidth, offsetY+screenHeight);
  Form1.Canvas.Line(offsetX+32*screenWidth+screenWidth, offsetY, (offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight);
  Form1.Canvas.Line(offsetX+32*screenWidth, offsetY+screenHeight, (offsetX+screenWidth)+32*screenWidth, offsetY+screenHeight);
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
  if offsetY>mapHeight-screenHeight-1 then
     offsetY:=mapHeight-screenHeight-1;

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
           UpdateTilemapTile(tilePos.x, tilepos.y, 5);
         end

       // Click Tile
       else
         DebugTile(TilePos.X, TilePos.Y);

       //DrawMap();
     end;

  // Klick in Minimap
  if (mousePos.X > (screenWidth*32)) and (mousePos.Y < mapHeight) then
     MoveCamera(mousePos.X-(screenWidth*32)-Round(screenWidth/2), mousePos.Y-Round(screenHeight/2));
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


