/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file UserInfoCard.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-10-12
 * @desc
 */

import { AppConstants, ColorConstants, FontSizeConstants, TypeUtils } from "@mxz/component"
import { FLabel } from "../components/FLabel";

import { HealthCardDataType } from "../models/HealthDataModel";
import { Gender } from "../models/UserDataModel";


@ComponentV2
export struct UserInfoCard {
  @Param nickName: string = ""
  @Param nAge: number = 0; // 年龄
  @Param nGender: Gender = Gender.UNKNOWN;
  @Param nHeight: number = 0; // 身高，单位:cm
  @Event handleClick: () => void

  build() {
    RelativeContainer() {
      Row() {
        Image($r('app.media.bgImg')).height('100%')
      }.width('100%').justifyContent(FlexAlign.End)

      Column({ space: AppConstants.VIEW_SPACE / 2 }) {
        Row() {
          Text(this.nickName.length > 0 ? this.nickName : "请设置基本信息")
            .fontSize(FontSizeConstants.LargeTitle)
            .fontWeight(FontWeight.Medium)
            .fontColor(ColorConstants.Text_333)
        }
        .width('100%')
        .margin({ bottom: AppConstants.VIEW_MARGIN })
        .alignItems(VerticalAlign.Bottom)
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Row() {
            Row({ space: AppConstants.VIEW_SPACE }) {
              Row() {
                FLabel({ Label: "性别:" })

                Text(`${this.nGender}`)
                  .fontSize(FontSizeConstants.Large)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(ColorConstants.Text_333)
              }.alignItems(VerticalAlign.Bottom)

              Row() {
                FLabel({ Label: "年龄:" })

                Text(`${this.nAge}`)
                  .fontSize(FontSizeConstants.Large)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(ColorConstants.Text_333)

                if (!TypeUtils.isEmptyNumber(this.nAge)) {
                  FLabel({ Label: " 岁" })
                }
              }.alignItems(VerticalAlign.Bottom)

              Row() {
                FLabel({ Label: "身高:" })

                Text(`${this.nHeight}`)
                  .fontSize(FontSizeConstants.Large)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(ColorConstants.Text_333)

                if (!TypeUtils.isEmptyNumber(this.nHeight)) {
                  FLabel({ Label: " cm" })
                }
              }.alignItems(VerticalAlign.Bottom)
            }.alignItems(VerticalAlign.Bottom)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .layoutWeight(1)
        }
        .width('100%')
      }
    }
    .height(120)
    .width('100%')
    .padding(AppConstants.VIEW_PADDING)
    .backgroundColor(ColorConstants.White)
    .borderRadius(AppConstants.VIEW_RADIUS)
    .shadow({
      radius: AppConstants.VIEW_RADIUS,
      color: '#1a000000',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.handleClick()
    })
  }
}