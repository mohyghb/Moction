import 'package:moction/MoWidgets/MoNotNull.dart';
import 'package:flutter/material.dart';

class MoPadding{



  double paddingAll;
  double paddingLeft;
  double paddingRight;
  double paddingTop;
  double paddingBottom;

  double paddingWidths;
  double paddingHeights;

  double totalRightPadding;
  double totalLeftPadding;
  double totalTopPadding;
  double totalBottomPadding;


  EdgeInsets _padding;


  MoPadding({
    this.paddingAll,
    this.paddingLeft,
    this.paddingRight,
    this.paddingTop,
    this.paddingBottom,
    this.paddingWidths,
    this.paddingHeights,
    this.totalRightPadding,
    this.totalLeftPadding,
    this.totalTopPadding,
    this.totalBottomPadding,
    });

  EdgeInsets getPadding()
  {
    if(this._padding == null){
      initPadding();
    }
    return this._padding;
  }


  initPadding()
  {
    double totalPadding = MoNotNull.Double(this.paddingAll);
    totalRightPadding = MoNotNull.Double(this.paddingRight) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalLeftPadding = MoNotNull.Double(this.paddingLeft) + totalPadding + MoNotNull.Double(this.paddingWidths);
    totalTopPadding = MoNotNull.Double(this.paddingTop) + totalPadding + MoNotNull.Double(this.paddingHeights);
    totalBottomPadding = MoNotNull.Double(this.paddingBottom) + totalPadding + MoNotNull.Double(this.paddingHeights);
    this._padding = EdgeInsets.only(left: totalLeftPadding,right: totalRightPadding,top: totalTopPadding,bottom: totalBottomPadding);
  }



  /// magical line that will make this work
  /// padding: NotNull.Dynamic(this.padding,returnThis: MoPadding()).getPadding(),

}


class MoPaddingVersions{

  static const double UNIVERSAL_PADDING = 8.0;
  static MoPadding universal()
  {
    return MoPadding(
      paddingAll: MoPaddingVersions.UNIVERSAL_PADDING
    );
  }


  static EdgeInsets getNotNullPadding(MoPadding padding)
  {
    if(padding!=null){
      return padding.getPadding();
    }else{
      return EdgeInsets.all(0);
    }
  }


}