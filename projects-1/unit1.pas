unit Unit1;


{$mode objfpc}{$H+}

interface



uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Crt;

type

  { TForm1 }

  TForm1 = class(TForm)
    tmrMoveBall: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure tmrMoveBallTimer(Sender: TObject);

  private
    FBallX: integer;
    FballY: integer;
    FDirection: double;
    FSpeed: integer;
    FBatLeftX: integer;
    FBatRightX: integer;
    FBatRightY:integer;
    FBatLeftY: integer;
    FScreenCenterX: integer;
    FScreenCenterY: integer;
    FScoreLeft: integer;
    FScoreRight: integer;


    procedure DrawBall(const AXNew, AYNew: integer);
    procedure DrawBatRight(const AYNew: integer);
    procedure DrawBatLeft(const AYNew: integer);
    procedure BounceBallOnXAxis;
    procedure BounceBallOnYAxis;
    procedure StartGame;
    procedure Serve;
    procedure DisplayScore;
    procedure MakeSound(CFrequency,CTime :integer);
    procedure MakeLoseSound;





  public
    const CBatHeight = 80;
    const CBallSize = 15;

  end;

var
  Form1: TForm1;


implementation



{$R *.lfm}



{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.OnKeyPress := @FormKeyPress;

  Color:= clBlack;

  Height:= 600;
  Width:= 800;

  Position:= poScreenCenter;
    FScreenCenterX:=ClientWidth div 2;
    FScreenCenterY:=CLientHeight div 2;


    FBallX:= FScreenCenterX;
    FballY:= FScreenCenterY;

    FBatLeftX:= 30;
    FBatRightX:=CLientWIdth - 30 - CBallSize;

    FDirection:= 2/11;
    FSpeed:= 20;



    //tmrMoveBall.Enabled := True;

    Serve;


end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin



     if Ord(Key) = 27 then            {Terminate}
        begin

          Application.Terminate;

        end;

     if Ord(Key) = 32 then            {Start Program}
        begin


             StartGame;
        end;


     if Ord(Key) = 109 then            {Right bat down, key m}
        begin

             DrawBatRight(FBatRightY + 20);

        end;

     if Ord(Key) = 107 then            {Right bat up, key k}
        begin

             DrawBatRight(FBatRightY - 20);

        end;

     if Ord(Key) = 120 then            {Left bat down, key x}
        begin

             DrawBatLeft(FBatLeftY + 20);

        end;

     if Ord(Key) = 115 then            {Left bat up, key s}
        begin

             DrawBatLeft(FBatLeftY - 20);

        end;


end;

procedure TForm1.tmrMoveBallTimer(Sender: TObject);
var
  LXChange: integer;
  LYChange: integer;
begin
     LXChange := Round(cos(FDirection) * FSpeed);
     LYChange := Round(sin(FDirection) * FSpeed);

     DrawBall(FBallX + LXChange, FBallY + LYChange);



end;


procedure TForm1.DrawBall(const AXNew, AYNew: integer);
begin

           Canvas.Brush.Color:= clBlack;
           Canvas.Ellipse(FBallX,FBallY,FBallX + 15,FBallY + 15);
           Canvas.Brush.Color:= clWhite;
           Canvas.Ellipse(AXNew,AYNew,AXNew + 15,AYNew + 15);
           FBallX:= AXNew;
           FBallY:= AYNew;

           if (FBallX <= CBallSize) then
  begin
    Inc(FScoreRight);
    MakeLoseSound;
    Serve;
  end
  else if (FBallX >= ClientWidth - CBallSize) then
  begin
    Inc(FScoreLeft);
    MakeLoseSound;
    Serve;
  end
     else if(FBAllY <= 0) or (FBallY >= CLientHeight - CBallSize) then
          begin
               MakeSound(300,500);
               BounceBallOnYAxis;
          end
          else if
               (FBallX + CBallSize >= FBatRightX) and
               (FBallY >= FBatRightY) and
               (FBallY + CBallSize <= FBatRightY + CBatHeight) then
                       begin
                            MakeSound(400,500);
                            BounceBallOnXAxis;
                       end


                       else if
                            (FBallX <= FBatLeftX + CBallSize) and
                            (FBallY >= FBatLeftY) and
                            (FBallY + CBallSize <= FBatLeftY + CBatHeight) then
                                    begin
                                         MakeSound(400,500);
                                         BounceBallOnXAxis;

                                    end;

end;

procedure TForm1.DrawBatRight(const AYNew: integer);

begin
           if (AYNew <= 0) or (AYNew + CBatHeight >= ClientHeight) then
              Exit;


           Canvas.Brush.Color:=clBlack;
           Canvas.Rectangle(FBatRightX,FBatRightY,FBatRightX + CBallSize,FBatRightY + CBatHeight);
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(FBatRightX,AYNew,FBatRightX + CBallSize,AYNew + CBatHeight);

           FBatRightY:= AYNew;

end;

procedure TForm1.DrawBatLeft(const AYNew: integer);

begin
           if (AYNew <= 0) or (AYNew + CBatHeight >= ClientHeight) then
              Exit;

           Canvas.Brush.Color:=clBlack;
           Canvas.Rectangle(FBatLeftX,FBatLeftY,FBatLeftX + CBallSize,FBatLeftY + CBatHeight);
           Canvas.Brush.Color:=clWhite;
           Canvas.Rectangle(FBatLeftX,AYNew,FBatLeftX + CBallSize,AYNew + CBatHeight);

           FBatLeftY:= AYNew;




end;

procedure TForm1.BounceBallOnXAxis;
begin
     FDirection:= (Pi - FDirection);

end;

procedure TForm1.BounceBallOnYAxis;
begin
     FDirection:=  (2*Pi - FDirection);

end;

procedure TForm1.StartGame;
begin
     FScoreLeft:= 0;
    FScoreRight:= 0;
    Serve;
end;

procedure TForm1.Serve;
begin
  tmrMoveBall.Enabled := False;
  Repaint;
  DrawBall(FScreenCenterX, FScreenCenterY);
  DrawBatRight(FScreenCenterY);
  DrawBatLeft(FScreenCenterY);
  DisplayScore;
  Sleep(2000);
  tmrMoveBall.Enabled := True;
end;


procedure TForm1.DisplayScore;
begin
     Canvas.Font.Name:= 'Courier New';
     Canvas.Font.Size:=30;
     Canvas.Font.Style:=[fsBold];
     Canvas.Font.Color:= clWhite;
     Canvas.Brush.Color:= clBlack;
     Canvas.TextOut(FScreenCenterX - 50, 30, IntToStr(FScoreLeft));
     Canvas.TextOut(FScreenCenterX + 50, 30, IntToStr(FScoreRight));
end;

procedure TForm1.MakeSound(CFrequency, CTime: integer);
begin
     Sound(CFrequency);
     Sleep(CTime);
     NoSound;
end;

procedure TForm1.MakeLoseSound;
begin
     Sound(523);
     Sleep(500);
     NoSound;
end;




end.
