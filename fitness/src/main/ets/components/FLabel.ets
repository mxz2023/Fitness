/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file FLabel.ets
 * @project Fitness
 * @author vincent_gemini
 * @crateTime 2025-11-04
 * @desc
 */

import { ColorConstants, FontSizeConstants } from "@mxz/component"


@ComponentV2
export struct FLabel {
  @Param Label: string = ''
  @Param fontColor: string = ColorConstants.Text_666
  private fontSize: number = FontSizeConstants.Normal

  build() {
    Row() {
      Text(`${this.Label}`)
        .fontSize(this.fontSize)
        .fontColor(this.fontColor)
        .lineHeight(24)
        .margin({
          right: 4
        })
    }
  }
}