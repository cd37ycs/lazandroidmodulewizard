unit linearlayout;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

 TLinearLayoutOrientation = (loHorizontal, loVertical);
{Draft Component code by "Lazarus Android Module Wizard" [12/17/2017 1:52:22]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jLinearLayout = class(jVisualControl)
 private
    FOrientation: TLinearLayoutOrientation;
    procedure SetVisible(Value: Boolean);
    procedure SetColor(Value: TARGBColorBridge); //background
    procedure UpdateLParamHeight;
    procedure UpdateLParamWidth;
    procedure TryNewParent(refApp: jApp);
 public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Init(refApp: jApp); override;
    procedure Refresh;
    procedure UpdateLayout; override;
    procedure ClearLayout;

    //procedure GenEvent_OnClick(Obj: TObject);
    function jCreate(): jObject;
    procedure jFree();
    procedure SetViewParent(_viewgroup: jObject); override;
    function GetViewParent(): jObject; override;
    procedure RemoveFromViewParent();  override;
    function GetView(): jObject;  override;
    procedure SetLParamWidth(_w: integer);
    procedure SetLParamHeight(_h: integer);
    function GetLParamWidth(): integer;
    function GetLParamHeight(): integer;
    procedure SetLGravity(_gravity: TLayoutGravity);
    procedure SetLWeight(_w: single);
    procedure SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
    procedure AddLParamsAnchorRule(_rule: integer);
    procedure AddLParamsParentRule(_rule: integer);
    procedure SetLayoutAll(_idAnchor: integer);
    procedure ClearLayoutAll();
    procedure SetId(_id: integer);
    procedure SetOrientation(_orientation: TLinearLayoutOrientation);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    property Orientation: TLinearLayoutOrientation read FOrientation write SetOrientation;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;
    //property OnClick: TOnNotify read FOnClick write FOnClick;

end;

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);


implementation

uses
   customdialog, viewflipper, toolbar, scoordinatorlayout,
   sdrawerlayout, scollapsingtoolbarlayout, scardview, sappbarlayout,
   stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;


{---------  jLinearLayout  --------------}

constructor jLinearLayout.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 0;
  FMarginTop    := 0;
  FMarginBottom := 0;
  FMarginRight  := 0;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
 //FOrientation:= loHorizontal;
end;

destructor jLinearLayout.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
     if FjObject <> nil then
     begin
       jFree();
       FjObject:= nil;
     end;
  end;
  //you others free code here...'
  inherited Destroy;
end;

procedure jLinearLayout.TryNewParent(refApp: jApp);
begin
  if FParent is jPanel then
  begin
    jPanel(FParent).Init(refApp);
    FjPRLayout:= jPanel(FParent).View;
  end else
  if FParent is jScrollView then
  begin
    jScrollView(FParent).Init(refApp);
    FjPRLayout:= jScrollView_getView(FjEnv, jScrollView(FParent).jSelf);
  end else
  if FParent is jHorizontalScrollView then
  begin
    jHorizontalScrollView(FParent).Init(refApp);
    FjPRLayout:= jHorizontalScrollView_getView(FjEnv, jHorizontalScrollView(FParent).jSelf);
  end  else
  if FParent is jCustomDialog then
  begin
    jCustomDialog(FParent).Init(refApp);
    FjPRLayout:= jCustomDialog(FParent).View;
  end else
  if FParent is jViewFlipper then
  begin
    jViewFlipper(FParent).Init(refApp);
    FjPRLayout:= jViewFlipper(FParent).View;
  end else
  if FParent is jToolbar then
  begin
    jToolbar(FParent).Init(refApp);
    FjPRLayout:= jToolbar(FParent).View;
  end  else
  if FParent is jsToolbar then
  begin
    jsToolbar(FParent).Init(refApp);
    FjPRLayout:= jsToolbar(FParent).View;
  end  else
  if FParent is jsCoordinatorLayout then
  begin
    jsCoordinatorLayout(FParent).Init(refApp);
    FjPRLayout:= jsCoordinatorLayout(FParent).View;
  end else
  if FParent is jFrameLayout then
  begin
    jFrameLayout(FParent).Init(refApp);
    FjPRLayout:= jFrameLayout(FParent).View;
  end else
  if FParent is jLinearLayout then
  begin
    jLinearLayout(FParent).Init(refApp);
    FjPRLayout:= jLinearLayout(FParent).View;
  end else
  if FParent is jsDrawerLayout then
  begin
    jsDrawerLayout(FParent).Init(refApp);
    FjPRLayout:= jsDrawerLayout(FParent).View;
  end  else
  if FParent is jsCardView then
  begin
      jsCardView(FParent).Init(refApp);
      FjPRLayout:= jsCardView(FParent).View;
  end else
  if FParent is jsAppBarLayout then
  begin
      jsAppBarLayout(FParent).Init(refApp);
      FjPRLayout:= jsAppBarLayout(FParent).View;
  end else
  if FParent is jsTabLayout then
  begin
      jsTabLayout(FParent).Init(refApp);
      FjPRLayout:= jsTabLayout(FParent).View;
  end else
  if FParent is jsCollapsingToolbarLayout then
  begin
      jsCollapsingToolbarLayout(FParent).Init(refApp);
      FjPRLayout:= jsCollapsingToolbarLayout(FParent).View;
  end else
  if FParent is jsNestedScrollView then
  begin
      jsNestedScrollView(FParent).Init(refApp);
      FjPRLayout:= jsNestedScrollView(FParent).View;
  end else
  if FParent is jsViewPager then
  begin
      jsViewPager(FParent).Init(refApp);
      FjPRLayout:= jsViewPager(FParent).View;
  end;
end;

procedure jLinearLayout.Init(refApp: jApp);
var
  rToP: TPositionRelativeToParent;
  rToA: TPositionRelativeToAnchorID;
begin
  if FInitialized  then Exit;
  inherited Init(refApp); //set default ViewParent/FjPRLayout as jForm.View!
  //your code here: set/initialize create params....
  FjObject:= jCreate(); //jSelf !
  FInitialized:= True;

  if FParent <> nil then
  begin
    TryNewParent(refApp);
  end;

  FjPRLayoutHome:= FjPRLayout;

  if FOrientation <> loHorizontal then
       jLinearLayout_SetOrientation(FjEnv, FjObject, Ord(FOrientation));

  if FGravityInParent <> lgNone then
     jLinearLayout_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent) );

  jLinearLayout_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jLinearLayout_SetId(FjEnv, FjObject, Self.Id);
  jLinearLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
                        FMarginLeft,FMarginTop,FMarginRight,FMarginBottom,
                        GetLayoutParams(gApp, FLParamWidth, sdW),
                        GetLayoutParams(gApp, FLParamHeight, sdH));

  if FParent is jPanel then
  begin
    Self.UpdateLayout;
  end;

  for rToA := raAbove to raAlignRight do
  begin
    if rToA in FPositionRelativeToAnchor then
    begin
      jLinearLayout_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jLinearLayout_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jLinearLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if  FColor <> colbrDefault then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jLinearLayout.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
    View_SetBackGroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;
procedure jLinearLayout.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jLinearLayout.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jLinearLayout_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jLinearLayout_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jLinearLayout_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jLinearLayout.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jLinearLayout_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jLinearLayout_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jLinearLayout_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jLinearLayout.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jLinearLayout_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jLinearLayout.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jLinearLayout.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jLinearLayout_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jLinearLayout_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jLinearLayout_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

(*
//Event : Java -> Pascal
procedure jLinearLayout.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jLinearLayout.jCreate(): jObject;
begin
   Result:= jLinearLayout_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jLinearLayout.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_jFree(FjEnv, FjObject);
end;

procedure jLinearLayout.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jLinearLayout.GetViewParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetParent(FjEnv, FjObject);
end;

procedure jLinearLayout.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_RemoveFromViewParent(FjEnv, FjObject);
end;

function jLinearLayout.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetView(FjEnv, FjObject);
end;

procedure jLinearLayout.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jLinearLayout.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetLParamWidth(FjEnv, FjObject);
end;

function jLinearLayout.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jLinearLayout_GetLParamHeight(FjEnv, FjObject);
end;

procedure jLinearLayout.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jLinearLayout_SetLGravity(FjEnv, FjObject, Ord(_gravity) );
end;

procedure jLinearLayout.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jLinearLayout.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jLinearLayout.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jLinearLayout.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jLinearLayout.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jLinearLayout.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jLinearLayout.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jLinearLayout_SetId(FjEnv, FjObject, _id);
end;

procedure jLinearLayout.SetOrientation(_orientation: TLinearLayoutOrientation);
begin
  //in designing component state: set value here...
  FOrientation:= _orientation;
  if FInitialized then
     jLinearLayout_SetOrientation(FjEnv, FjObject, Ord(FOrientation));
end;

{-------- jLinearLayout_JNI_Bridge ----------}

function jLinearLayout_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jLinearLayout_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;

(*
//Please, you need insert:

public java.lang.Object jLinearLayout_jCreate(long _Self) {
  return (java.lang.Object)(new jLinearLayout(this,_Self));
}

//to end of "public class Controls" in "Controls.java"
*)


procedure jLinearLayout_jFree(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetViewParent(env: PJNIEnv; _jlinearlayout: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetParent(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_RemoveFromViewParent(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetView(env: PJNIEnv; _jlinearlayout: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamWidth(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jLinearLayout_GetLParamHeight(env: PJNIEnv; _jlinearlayout: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLGravity(env: PJNIEnv; _jlinearlayout: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLWeight(env: PJNIEnv; _jlinearlayout: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jlinearlayout: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
var
  jParams: array[0..5] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jParams[4].i:= _w;
  jParams[5].i:= _h;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsAnchorRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_AddLParamsParentRule(env: PJNIEnv; _jlinearlayout: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetLayoutAll(env: PJNIEnv; _jlinearlayout: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_ClearLayoutAll(env: PJNIEnv; _jlinearlayout: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jlinearlayout, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetId(env: PJNIEnv; _jlinearlayout: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jLinearLayout_SetOrientation(env: PJNIEnv; _jlinearlayout: JObject; _orientation: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _orientation;
  jCls:= env^.GetObjectClass(env, _jlinearlayout);
  jMethod:= env^.GetMethodID(env, jCls, 'SetOrientation', '(I)V');
  env^.CallVoidMethodA(env, _jlinearlayout, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;



end.
