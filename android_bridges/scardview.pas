unit scardview;

{$mode delphi}

interface

uses
  Classes, SysUtils, And_jni, And_jni_Bridge, AndroidWidget, Laz_And_Controls;

type

{Draft Component code by "Lazarus Android Module Wizard" [12/20/2017 21:49:51]}
{https://github.com/jmpessoa/lazandroidmodulewizard}

{jVisualControl template}

jsCardView = class(jVisualControl)
 private
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
    function GetParent(): jObject;
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
    procedure SetCardElevation(_elevation: single);
    procedure SetContentPadding(_left: integer; _top: integer; _right: integer; _bottom: integer);
    procedure SetFitsSystemWindows(_value: boolean);
    procedure SetRadius(_radius: single);

 published
    property BackgroundColor: TARGBColorBridge read FColor write SetColor;
    //property OnClick: TOnNotify read FOnClick write FOnClick;
    property GravityInParent: TLayoutGravity read FGravityInParent write SetLGravity;

end;

function jsCardView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
procedure jsCardView_jFree(env: PJNIEnv; _jscardview: JObject);
procedure jsCardView_SetViewParent(env: PJNIEnv; _jscardview: JObject; _viewgroup: jObject);
function jsCardView_GetParent(env: PJNIEnv; _jscardview: JObject): jObject;
procedure jsCardView_RemoveFromViewParent(env: PJNIEnv; _jscardview: JObject);
function jsCardView_GetView(env: PJNIEnv; _jscardview: JObject): jObject;
procedure jsCardView_SetLParamWidth(env: PJNIEnv; _jscardview: JObject; _w: integer);
procedure jsCardView_SetLParamHeight(env: PJNIEnv; _jscardview: JObject; _h: integer);
function jsCardView_GetLParamWidth(env: PJNIEnv; _jscardview: JObject): integer;
function jsCardView_GetLParamHeight(env: PJNIEnv; _jscardview: JObject): integer;
procedure jsCardView_SetLGravity(env: PJNIEnv; _jscardview: JObject; _g: integer);
procedure jsCardView_SetLWeight(env: PJNIEnv; _jscardview: JObject; _w: single);
procedure jsCardView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscardview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
procedure jsCardView_AddLParamsAnchorRule(env: PJNIEnv; _jscardview: JObject; _rule: integer);
procedure jsCardView_AddLParamsParentRule(env: PJNIEnv; _jscardview: JObject; _rule: integer);
procedure jsCardView_SetLayoutAll(env: PJNIEnv; _jscardview: JObject; _idAnchor: integer);
procedure jsCardView_ClearLayoutAll(env: PJNIEnv; _jscardview: JObject);
procedure jsCardView_SetId(env: PJNIEnv; _jscardview: JObject; _id: integer);
procedure jsCardView_SetCardElevation(env: PJNIEnv; _jscardview: JObject; _elevation: single);
procedure jsCardView_SetCardBackgroundColor(env: PJNIEnv; _jscardview: JObject; _color: integer);
procedure jsCardView_SetContentPadding(env: PJNIEnv; _jscardview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer);
procedure jsCardView_SetFitsSystemWindows(env: PJNIEnv; _jscardview: JObject; _value: boolean);
procedure jsCardView_SetRadius(env: PJNIEnv; _jscardview: JObject; _radius: single);

implementation

uses
  customdialog, viewflipper, toolbar, scoordinatorlayout, linearlayout,
  sdrawerlayout, scollapsingtoolbarlayout, sappbarlayout,
  stoolbar, stablayout, snestedscrollview, sviewpager, framelayout;


{---------  jsCardView  --------------}

constructor jsCardView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMarginLeft   := 4;
  FMarginTop    := 4;
  FMarginBottom := 4;
  FMarginRight  := 4;
  FHeight       := 96; //??
  FWidth        := 192; //??
  FLParamWidth  := lpMatchParent;  //lpWrapContent
  FLParamHeight := lpWrapContent; //lpMatchParent
  FAcceptChildrenAtDesignTime:= True;
//your code here....
end;

destructor jsCardView.Destroy;
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

procedure jsCardView.TryNewParent(refApp: jApp);
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
procedure jsCardView.Init(refApp: jApp);
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

  if FGravityInParent <> lgNone then
    jsCardView_SetLGravity(FjEnv, FjObject, Ord(FGravityInParent));

  jsCardView_SetViewParent(FjEnv, FjObject, FjPRLayout);
  jsCardView_SetId(FjEnv, FjObject, Self.Id);
  jsCardView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject,
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
      jsCardView_AddLParamsAnchorRule(FjEnv, FjObject, GetPositionRelativeToAnchor(rToA));
    end;
  end;
  for rToP := rpBottom to rpCenterVertical do
  begin
    if rToP in FPositionRelativeToParent then
    begin
      jsCardView_AddLParamsParentRule(FjEnv, FjObject, GetPositionRelativeToParent(rToP));
    end;
  end;

  if Self.Anchor <> nil then Self.AnchorId:= Self.Anchor.Id
  else Self.AnchorId:= -1; //dummy

  jsCardView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);

  if FColor <> colbrDefault then
    jsCardView_SetCardBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));

  View_SetVisible(FjEnv, FjObject, FVisible);
end;

procedure jsCardView.SetColor(Value: TARGBColorBridge);
begin
  FColor:= Value;
  if (FInitialized = True) and (FColor <> colbrDefault)  then
       jsCardView_SetCardBackgroundColor(FjEnv, FjObject, GetARGB(FCustomColor, FColor));
end;

procedure jsCardView.SetVisible(Value : Boolean);
begin
  FVisible:= Value;
  if FInitialized then
    View_SetVisible(FjEnv, FjObject, FVisible);
end;
procedure jsCardView.UpdateLParamWidth;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart  then side:= sdW else side:= sdH;
      jsCardView_SetLParamWidth(FjEnv, FjObject, GetLayoutParams(gApp, FLParamWidth, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamWidth = lpWrapContent then
        jsCardView_setLParamWidth(FjEnv, FjObject , GetLayoutParams(gApp, FLParamWidth, sdW))
      else //lpMatchParent or others
        jsCardView_setLParamWidth(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamWidth, sdW));
    end;
  end;
end;

procedure jsCardView.UpdateLParamHeight;
var
  side: TSide;
begin
  if FInitialized then
  begin
    if Self.Parent is jForm then
    begin
      if jForm(Owner).ScreenStyle = (FParent as jForm).ScreenStyleAtStart then side:= sdH else side:= sdW;
      jsCardView_SetLParamHeight(FjEnv, FjObject, GetLayoutParams(gApp, FLParamHeight, side));
    end
    else
    begin
      if (Self.Parent as jVisualControl).LayoutParamHeight = lpWrapContent then
        jsCardView_setLParamHeight(FjEnv, FjObject , GetLayoutParams(gApp, FLParamHeight, sdH))
      else //lpMatchParent and others
        jsCardView_setLParamHeight(FjEnv,FjObject,GetLayoutParamsByParent((Self.Parent as jVisualControl), FLParamHeight, sdH));
    end;
  end;
end;

procedure jsCardView.UpdateLayout;
begin
  if FInitialized then
  begin
    inherited UpdateLayout;
    UpdateLParamWidth;
    UpdateLParamHeight;
  jsCardView_SetLayoutAll(FjEnv, FjObject, Self.AnchorId);
  end;
end;

procedure jsCardView.Refresh;
begin
  if FInitialized then
    View_Invalidate(FjEnv, FjObject);
end;

procedure jsCardView.ClearLayout;
var
   rToP: TPositionRelativeToParent;
   rToA: TPositionRelativeToAnchorID;
begin
 jsCardView_ClearLayoutAll(FjEnv, FjObject );
   for rToP := rpBottom to rpCenterVertical do
   begin
      if rToP in FPositionRelativeToParent then
        jsCardView_AddLParamsParentRule(FjEnv, FjObject , GetPositionRelativeToParent(rToP));
   end;
   for rToA := raAbove to raAlignRight do
   begin
     if rToA in FPositionRelativeToAnchor then
       jsCardView_AddLParamsAnchorRule(FjEnv, FjObject , GetPositionRelativeToAnchor(rToA));
   end;
end;

//Event : Java -> Pascal
(*
procedure jsCardView.GenEvent_OnClick(Obj: TObject);
begin
  if Assigned(FOnClick) then FOnClick(Obj);
end;
*)

function jsCardView.jCreate(): jObject;
begin
   Result:= jsCardView_jCreate(FjEnv, int64(Self), FjThis);
end;

procedure jsCardView.jFree();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_jFree(FjEnv, FjObject);
end;

procedure jsCardView.SetViewParent(_viewgroup: jObject);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetViewParent(FjEnv, FjObject, _viewgroup);
end;

function jsCardView.GetParent(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCardView_GetParent(FjEnv, FjObject);
end;

procedure jsCardView.RemoveFromViewParent();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_RemoveFromViewParent(FjEnv, FjObject);
end;

function jsCardView.GetView(): jObject;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCardView_GetView(FjEnv, FjObject);
end;

procedure jsCardView.SetLParamWidth(_w: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetLParamWidth(FjEnv, FjObject, _w);
end;

procedure jsCardView.SetLParamHeight(_h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetLParamHeight(FjEnv, FjObject, _h);
end;

function jsCardView.GetLParamWidth(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCardView_GetLParamWidth(FjEnv, FjObject);
end;

function jsCardView.GetLParamHeight(): integer;
begin
  //in designing component state: result value here...
  if FInitialized then
   Result:= jsCardView_GetLParamHeight(FjEnv, FjObject);
end;

procedure jsCardView.SetLGravity(_gravity: TLayoutGravity);
begin
  //in designing component state: set value here...
  FGravityInParent:= _gravity;
  if FInitialized then
     jsCardView_SetLGravity(FjEnv, FjObject, Ord(_gravity));
end;

procedure jsCardView.SetLWeight(_w: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetLWeight(FjEnv, FjObject, _w);
end;

procedure jsCardView.SetLeftTopRightBottomWidthHeight(_left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetLeftTopRightBottomWidthHeight(FjEnv, FjObject, _left ,_top ,_right ,_bottom ,_w ,_h);
end;

procedure jsCardView.AddLParamsAnchorRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_AddLParamsAnchorRule(FjEnv, FjObject, _rule);
end;

procedure jsCardView.AddLParamsParentRule(_rule: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_AddLParamsParentRule(FjEnv, FjObject, _rule);
end;

procedure jsCardView.SetLayoutAll(_idAnchor: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetLayoutAll(FjEnv, FjObject, _idAnchor);
end;

procedure jsCardView.ClearLayoutAll();
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_ClearLayoutAll(FjEnv, FjObject);
end;

procedure jsCardView.SetId(_id: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetId(FjEnv, FjObject, _id);
end;

procedure jsCardView.SetCardElevation(_elevation: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetCardElevation(FjEnv, FjObject, _elevation);
end;


procedure jsCardView.SetContentPadding(_left: integer; _top: integer; _right: integer; _bottom: integer);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetContentPadding(FjEnv, FjObject, _left ,_top ,_right ,_bottom);
end;

procedure jsCardView.SetFitsSystemWindows(_value: boolean);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetFitsSystemWindows(FjEnv, FjObject, _value);
end;

procedure jsCardView.SetRadius(_radius: single);
begin
  //in designing component state: set value here...
  if FInitialized then
     jsCardView_SetRadius(FjEnv, FjObject, _radius);
end;

{-------- jsCardView_JNI_Bridge ----------}

function jsCardView_jCreate(env: PJNIEnv;_Self: int64; this: jObject): jObject;
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].j:= _Self;
  jCls:= Get_gjClass(env);
  jMethod:= env^.GetMethodID(env, jCls, 'jsCardView_jCreate', '(J)Ljava/lang/Object;');
  Result:= env^.CallObjectMethodA(env, this, jMethod, @jParams);
  Result:= env^.NewGlobalRef(env, Result);
end;


procedure jsCardView_jFree(env: PJNIEnv; _jscardview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'jFree', '()V');
  env^.CallVoidMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetViewParent(env: PJNIEnv; _jscardview: JObject; _viewgroup: jObject);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].l:= _viewgroup;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetViewParent', '(Landroid/view/ViewGroup;)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCardView_GetParent(env: PJNIEnv; _jscardview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetParent', '()Landroid/view/ViewGroup;');
  Result:= env^.CallObjectMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_RemoveFromViewParent(env: PJNIEnv; _jscardview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'RemoveFromViewParent', '()V');
  env^.CallVoidMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCardView_GetView(env: PJNIEnv; _jscardview: JObject): jObject;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetView', '()Landroid/view/View;');
  Result:= env^.CallObjectMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLParamWidth(env: PJNIEnv; _jscardview: JObject; _w: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _w;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamWidth', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLParamHeight(env: PJNIEnv; _jscardview: JObject; _h: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _h;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLParamHeight', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCardView_GetLParamWidth(env: PJNIEnv; _jscardview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamWidth', '()I');
  Result:= env^.CallIntMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


function jsCardView_GetLParamHeight(env: PJNIEnv; _jscardview: JObject): integer;
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'GetLParamHeight', '()I');
  Result:= env^.CallIntMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLGravity(env: PJNIEnv; _jscardview: JObject; _g: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _g;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLGravity', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLWeight(env: PJNIEnv; _jscardview: JObject; _w: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _w;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLWeight', '(F)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLeftTopRightBottomWidthHeight(env: PJNIEnv; _jscardview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer; _w: integer; _h: integer);
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
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLeftTopRightBottomWidthHeight', '(IIIIII)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_AddLParamsAnchorRule(env: PJNIEnv; _jscardview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsAnchorRule', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_AddLParamsParentRule(env: PJNIEnv; _jscardview: JObject; _rule: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _rule;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'AddLParamsParentRule', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetLayoutAll(env: PJNIEnv; _jscardview: JObject; _idAnchor: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _idAnchor;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetLayoutAll', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_ClearLayoutAll(env: PJNIEnv; _jscardview: JObject);
var
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'ClearLayoutAll', '()V');
  env^.CallVoidMethod(env, _jscardview, jMethod);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetId(env: PJNIEnv; _jscardview: JObject; _id: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _id;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetId', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetCardElevation(env: PJNIEnv; _jscardview: JObject; _elevation: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _elevation;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCardElevation', '(F)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;


procedure jsCardView_SetCardBackgroundColor(env: PJNIEnv; _jscardview: JObject; _color: integer);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _color;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetCardBackgroundColor', '(I)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCardView_SetContentPadding(env: PJNIEnv; _jscardview: JObject; _left: integer; _top: integer; _right: integer; _bottom: integer);
var
  jParams: array[0..3] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].i:= _left;
  jParams[1].i:= _top;
  jParams[2].i:= _right;
  jParams[3].i:= _bottom;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetContentPadding', '(IIII)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCardView_SetFitsSystemWindows(env: PJNIEnv; _jscardview: JObject; _value: boolean);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].z:= JBool(_value);
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetFitsSystemWindows', '(Z)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

procedure jsCardView_SetRadius(env: PJNIEnv; _jscardview: JObject; _radius: single);
var
  jParams: array[0..0] of jValue;
  jMethod: jMethodID=nil;
  jCls: jClass=nil;
begin
  jParams[0].f:= _radius;
  jCls:= env^.GetObjectClass(env, _jscardview);
  jMethod:= env^.GetMethodID(env, jCls, 'SetRadius', '(F)V');
  env^.CallVoidMethodA(env, _jscardview, jMethod, @jParams);
  env^.DeleteLocalRef(env, jCls);
end;

end.
