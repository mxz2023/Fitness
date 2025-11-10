/**
 * 健康数据概览页面
 * 基于 Figma 设计实现的健康指标卡片式布局
 */
import { KeyboardAvoidMode } from '@kit.ArkUI';
import { display } from '@kit.ArkUI';

import {
  MIconButton,
  MDashBoardStyle,
  AppConstants,
  ColorConstants,
  showToast,
  getAppPathStack,
  NavigationTitleBuilder,
  FontSizeConstants
} from '@mxz/component';
import { MRouter } from '@mxz/router';

import {
  WeightData,
  BloodPressureData,
  BloodSugarData,
  UricAcidData,
  BloodLipidData,
  HealthCardData,
  HealthCardDataType
} from '../models/HealthDataModel';
import { UserDataModel } from '../models/UserDataModel';
import { UserViewModel } from '../viewmodels/UserViewModel';
import { WeightViewModel } from '../viewmodels/WeightViewModel';
import { BloodSugarViewModel } from '../viewmodels/BloodSugarViewModel';
import { BloodPressureViewModel } from '../viewmodels/BloodPressureViewModel';
import { UricAcidViewModel } from '../viewmodels/UricAcidViewModel';
import { BloodLipidViewModel } from '../viewmodels/BloodLipidViewModel';

import { HealthInfoCard } from './HealthInfoCard';
import { UserInfoCard } from './UserInfoCard';

import { UnitConstants } from '../common/HealthTypeDefine';
import { BaseInputDialog } from '../dialogs/BaseInputDialog';
import { WeightInputDialog } from '../dialogs/WeightInputDialog';
import { BloodSugarInputDialog } from '../dialogs/BloodSugarInputDialog';
import { UricAcidInputDialog } from '../dialogs/UricAcidInputDialog';
import { BloodPressureInputDialog } from '../dialogs/BloodPressureInputDialog';
import { BloodLipidInputDialog } from '../dialogs/BloodLipidInputDialog';


interface ToolItem {
  name: ResourceStr,
  x: number,
  y: number,
  handleClick: Function
}

@ComponentV2
export struct HealthPage {
  private pageInfos: NavPathStack = MRouter.getInstance().getNavStack();

  aboutToAppear(): void {
    // 获取默认 display 对象
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      const blockThis = this
      defaultDisplay.on('availableAreaChange', () => {
        const displayWidth = defaultDisplay.width; // 屏幕宽度
        const displayHeight = defaultDisplay.height; // 屏幕高度
      });
    } catch (error) {
      // TODO: Implement error handling.
    }
  }

  build() {
    RelativeContainer() {
      NavigationTitleBuilder(this.pageInfos, {
        title: {
          text: "叶记健康",
          fontSize: FontSizeConstants.LargeTitle,
          fontWeight: FontWeight.Medium
        },
        height: AppConstants.NAV_HEIGHT
      })
      Column() {
        HealthOverview()
      }
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })
      .margin({
        top: AppConstants.NAV_HEIGHT
      })
    }
  }
}

@ComponentV2
export struct HealthOverview {
  @Local private isLoading: boolean = true
  @Local private showQuick: boolean = true // 显示快速入口
  @Local private showExpandedButtons: boolean = false // 是否展开了
  @Local private buttonScale: number = 0
  @Local private buttonOpacity: number = 0
  @Provider("DashBoardStyle") dashBoardStyle: MDashBoardStyle = MDashBoardStyle.DashBoardNormal
  // 屏幕适配参数
  @Local private columnsTemplate: string = '1fr 1fr'
  @Local private dialogAlignment: DialogAlignment = DialogAlignment.Bottom
  private curWidth?:Length;

  private userInfoVM?: UserViewModel
  private weightDataVM?: WeightViewModel
  private bloodSugarVM?: BloodSugarViewModel
  private bloodPressVM?: BloodPressureViewModel
  private uricAcidVM?: UricAcidViewModel
  private bloodLipidVM?: BloodLipidViewModel
  private quickTools: Array<ToolItem> = []
  private baseDialogController?: CustomDialogController;
  private weightDialogController?: CustomDialogController;
  private bloodSugarDialogController?: CustomDialogController;
  private bloodPressDialogController?: CustomDialogController;
  private uricAcidDialogController?: CustomDialogController;
  private bloodLipidDialogController?: CustomDialogController;

  @Monitor('showType')
  onShowTypeChange(monitor: IMonitor) {
    // console.info(`path: ${monitor.value()?.path} change from ${monitor.value()?.before} to ${monitor.value()?.now}`);
    const value = monitor.value()?.now as HealthCardDataType
    if (value == HealthCardDataType.Unknown) {
      this.showQuick = true
    } else {
      this.showQuick = false
      this.hideExpandedButtons()
    }
  }

  // 窗口改变
  updateWindowSizeChange(displayWidth?: Length, displayHeight?: Length) {
    const curWidth = displayWidth
    if (curWidth == undefined) {
      return
    }
    if (this.curWidth == curWidth) {
      return
    }
    this.curWidth = curWidth
    // https://developer.huawei.com/consumer/cn/doc/design-guides/design-layout-basics-0000001795579413#section6149141345712
    // P60: 374x826
    // X5: 346x802 / 712x798
    // PuraX: 326x326 / 440x706
    // MatePad: 1280x800
    if (curWidth > 1000) {
      this.columnsTemplate = '1fr 1fr 1fr 1fr'
      this.dashBoardStyle = MDashBoardStyle.DashBoardBig
      this.dialogAlignment = DialogAlignment.Center
    } else if (curWidth > 600) {
      this.columnsTemplate = '1fr 1fr 1fr'
      this.dashBoardStyle = MDashBoardStyle.DashBoardBig
      this.dialogAlignment = DialogAlignment.Center
    } else if (curWidth > 350) {
      this.columnsTemplate = '1fr 1fr'
      this.dashBoardStyle = MDashBoardStyle.DashBoardNormal
      this.dialogAlignment = DialogAlignment.Bottom
    } else {
      this.columnsTemplate = '1fr 1fr'
      this.dashBoardStyle = MDashBoardStyle.DashBoardSmall
      this.dialogAlignment = DialogAlignment.Bottom
    }

    // 修改 dialog 展示
    if (this.baseDialogController) {
      const currentState: PromptActionCommonState = this.baseDialogController.getState();
      if (currentState === 3) {
        this.showBaseInputDialog()
      }
    }
    if (this.weightDialogController) {
      const currentState: PromptActionCommonState = this.weightDialogController.getState();
      if (currentState === 3) {
        this.showWeightDialog()
      }
    }
    if (this.bloodSugarDialogController) {
      const currentState: PromptActionCommonState = this.bloodSugarDialogController.getState();
      if (currentState === 3) {
        this.showBloodSugarDialog()
      }
    }
    if (this.uricAcidDialogController) {
      const currentState: PromptActionCommonState = this.uricAcidDialogController.getState();
      if (currentState === 3) {
        this.showUricAcidDialog()
      }
    }
    if (this.bloodPressDialogController) {
      const currentState: PromptActionCommonState = this.bloodPressDialogController.getState();
      if (currentState === 3) {
        this.showBloodPressureDialog()
      }
    }
    if (this.bloodLipidDialogController) {
      const currentState: PromptActionCommonState = this.bloodLipidDialogController.getState();
      if (currentState === 3) {
        this.showBloodLipidDialog()
      }
    }
  }

  async aboutToAppear(): Promise<void> {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);

    // 获取默认 display 对象
    try {
      const defaultDisplay = display.getDefaultDisplaySync();
      defaultDisplay.on('availableAreaChange', () => {
        const displayWidth = defaultDisplay.width;   // 屏幕宽度
        const displayHeight = defaultDisplay.height; // 屏幕高度
        this.updateWindowSizeChange(displayWidth, displayHeight)
      });
    } catch (error) {
      // TODO: Implement error handling.
    }


    this.quickTools = [
      {
        name: $r('app.media.weight'),
        x: -200,
        y: 0,
        handleClick: () => {
          this.showWeightDialog()
        }
      },
      {
        name: $r('app.media.blood_sugar'),
        x: -130,
        y: -130,
        handleClick: () => {
          this.showBloodSugarDialog()
        }
      },
      {
        name: $r('app.media.uric_acid'),
        x: 0,
        y: -200,

        handleClick: () => {
          this.showUricAcidDialog()
        }
      },
      {
        name: $r('app.media.blood_pressure'),
        x: 130,
        y: -130,
        handleClick: () => {
          this.showBloodPressureDialog()
        }
      },
      {
        name: $r('app.media.blood_lipid'),
        x: 200,
        y: 0,
        handleClick: () => {
          this.showBloodLipidDialog()
        }
      }
    ]

    await this.loadLastData()
  }

  /**
   * 加载数据
   */
  private async loadLastData() {
    const context = this.getUIContext().getHostContext()
    if (!context) {
      return
    }
    this.isLoading = true

    // 用户信息
    this.userInfoVM = new UserViewModel()
    await this.userInfoVM.initDataService(context)
    await this.userInfoVM.loadUserData()

    // 体重信息
    this.weightDataVM = new WeightViewModel(this.userInfoVM.heightCm)
    await this.weightDataVM.initDataService(context)
    await this.weightDataVM.getHealthData()

    // 血糖信息
    this.bloodSugarVM = new BloodSugarViewModel()
    await this.bloodSugarVM.initDataService(context)
    await this.bloodSugarVM.getHealthData()

    // 尿酸信息
    this.uricAcidVM = new UricAcidViewModel()
    await this.uricAcidVM.initDataService(context)
    await this.uricAcidVM.getHealthData()

    // 血压信息
    this.bloodPressVM = new BloodPressureViewModel()
    await this.bloodPressVM.initDataService(context)
    await this.bloodPressVM.getHealthData()

    // 血脂信息
    this.bloodLipidVM = new BloodLipidViewModel()
    await this.bloodLipidVM.initDataService(context)
    await this.bloodLipidVM.getHealthData()

    this.isLoading = false
  }

  // 获取健康卡片数据
  private getHealthCardData(): HealthCardData[] {
    if (this.userInfoVM == undefined || this.weightDataVM == undefined || this.bloodSugarVM == undefined ||
      this.uricAcidVM == undefined || this.bloodPressVM == undefined || this.bloodLipidVM == undefined) {
      return []
    }
    return [
      {
        title: '体重',
        type: HealthCardDataType.WeightInfo,
        value1: this.weightDataVM.value,
        unit: UnitConstants.WEIGHT_UNIT,
        status: this.weightDataVM.getHealthStatus(),
        date: this.weightDataVM.dateStr,
        // other: this.weightDataVM.getHealthAdvice()
      },
      {
        title: '血糖',
        type: HealthCardDataType.BloodSugarInfo,
        value1: this.bloodSugarVM.value,
        unit: UnitConstants.BLOOD_SUGAR_UNIT,
        status: this.bloodSugarVM.getHealthStatus(),
        date: this.bloodSugarVM.dateStr,
        // other: this.bloodSugarVM.getHealthAdvice()
      },
      {
        title: '尿酸',
        type: HealthCardDataType.UricAcidInfo,
        value1: this.uricAcidVM.value,
        unit: UnitConstants.URIC_ACID_UNIT,
        status: this.uricAcidVM.getHealthStatus(),
        date: this.uricAcidVM.dateStr,
        // other: this.uricAcidVM.getHealthAdvice()
      },
      {
        title: '血压',
        type: HealthCardDataType.BloodPressureInfo,
        value1: this.bloodPressVM.systolic,
        value2: this.bloodPressVM.diastolic,
        unit: UnitConstants.BLOOD_PRESSURE_UNIT,
        status: this.uricAcidVM.getHealthStatus(),
        date: this.uricAcidVM.dateStr,
        // other: this.uricAcidVM.getHealthAdvice()
      },
      {
        title: '血脂',
        type: HealthCardDataType.BloodLipidInfo,
        value1: this.bloodLipidVM.totalCholesterol,
        value2: this.bloodLipidVM.triglycerides,
        value3: this.bloodLipidVM.hdlCholesterol,
        value4: this.bloodLipidVM.ldlCholesterol,
        unit: UnitConstants.CHOLESTEROL_UNIT,
        status: this.bloodLipidVM.getHealthStatus(),
        date: this.bloodLipidVM.dateStr,
        // other: this.uricAcidVM.getHealthAdvice()
      },
    ];
  }

  // 更新用户基本信息
  private updateUserInfo(data: UserDataModel) {
    if (!this.userInfoVM) {
      return
    }

    let res = this.userInfoVM.setNickname(data.nickname)
    if (!res) {
      showToast(this.getUIContext(), "请输入正确的昵称")
      return
    }
    res = this.userInfoVM.setGender(data.gender)
    if (!res) {
      showToast(this.getUIContext(), "请输选择一个性别")
      return
    }
    res = this.userInfoVM.setAge(data.age)
    if (!res) {
      showToast(this.getUIContext(), "请输选择出生年份")
      return
    }
    res = this.userInfoVM.setHeightCm(data.heightCm)
    if (!res) {
      showToast(this.getUIContext(), "请输输入你的身高")
      return
    }
    this.userInfoVM.saveUserData().then((isOK: boolean) => {
      if (isOK) {
        // 用户信息更新后，更新一下体重VM中的身高
        if (this.weightDataVM && this.userInfoVM) {
          this.weightDataVM.height = this.userInfoVM.heightCm
        }
        showToast(this.getUIContext(), "保存数据成功")
      } else {
        showToast(this.getUIContext(), "保存数据失败")
      }
    })
  }

  // 更新体重信息
  private async updateWeight(data: WeightData) {
    if (!this.weightDataVM) {
      return
    }

    this.weightDataVM.value = data.value
    const res = await this.weightDataVM.saveData()
    if (res) {
      showToast(this.getUIContext(), "保存数据成功")
    } else {
      showToast(this.getUIContext(), "保存数据失败")
    }
  }

  // 更新血糖信息
  private async updateBloodSugar(data: BloodSugarData) {
    if (!this.bloodSugarVM) {
      return
    }
    this.bloodSugarVM.value = data.value
    this.bloodSugarVM.measurementType = data.measurementType
    const res = await this.bloodSugarVM.saveData()
    if (res) {
      showToast(this.getUIContext(), "保存数据成功")
    } else {
      showToast(this.getUIContext(), "保存数据失败")
    }
  }

  // 更新尿酸信息
  private async updateUricAcid(data: UricAcidData) {
    if (!this.uricAcidVM) {
      return
    }
    this.uricAcidVM.value = data.value
    this.uricAcidVM.gender = data.gender
    const res = await this.uricAcidVM.saveData()
    if (res) {
      showToast(this.getUIContext(), "保存数据成功")
    } else {
      showToast(this.getUIContext(), "保存数据失败")
    }
  }

  // 更新血压信息
  private async updateBloodPressure(data: BloodPressureData) {
    if (!this.bloodPressVM) {
      return
    }
    this.bloodPressVM.systolic = data.systolic
    this.bloodPressVM.diastolic = data.diastolic
    const res = await this.bloodPressVM.saveData()
    if (res) {
      showToast(this.getUIContext(), "保存数据成功")
    } else {
      showToast(this.getUIContext(), "保存数据失败")
    }
  }

  // 更新血脂信息
  private async updateBloodLipid(data: BloodLipidData) {
    if (!this.bloodLipidVM) {
      return
    }
    this.bloodLipidVM.totalCholesterol = data.totalCholesterol
    this.bloodLipidVM.triglycerides = data.triglycerides
    this.bloodLipidVM.hdlCholesterol = data.hdlCholesterol
    this.bloodLipidVM.ldlCholesterol = data.ldlCholesterol
    const res = await this.bloodLipidVM.saveData()
    if (res) {
      showToast(this.getUIContext(), "保存数据成功")
    } else {
      showToast(this.getUIContext(), "保存数据失败")
    }
  }

  getTextByType(type: HealthCardDataType) {
    switch (type) {
      case HealthCardDataType.WeightInfo: {
        return "weight"
      }
      case HealthCardDataType.BloodSugarInfo: {
        return "bloodSugar"
      }
      case HealthCardDataType.UricAcidInfo: {
        return "uricAcid"
      }
      case HealthCardDataType.BloodPressureInfo: {
        return "bloodPressure"
      }
      case HealthCardDataType.BloodLipidInfo: {
        return "bloodLipid"
      }
      default: {
        return ""
      }
    }
  }

  // 隐藏扩展按钮
  private hideExpandedButtons() {
    this.buttonScale = 0
    this.buttonOpacity = 0
    this.showExpandedButtons = false
  }

  private showBaseInputDialog() {
    if (this.baseDialogController) {
      this.baseDialogController.close()
      this.baseDialogController = undefined
    }
    this.baseDialogController = new CustomDialogController({
      builder: BaseInputDialog({
        nickname: this.userInfoVM!.nickname,
        gender: this.userInfoVM!.gender,
        heightCm: this.userInfoVM!.heightCm,
        age: this.userInfoVM!.age,
        onSubmit: (res) => {
          if (res) {
            this.updateUserInfo(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.baseDialogController.open()
  }

  private showWeightDialog() {
    if (this.weightDialogController) {
      this.weightDialogController.close()
      this.weightDialogController = undefined
    }
    this.weightDialogController = new CustomDialogController({
      builder: WeightInputDialog({
        weightKg: this.weightDataVM!.value,
        onSubmit: (res) => {
          if (res) {
            this.updateWeight(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.weightDialogController.open()
  }

  private showBloodSugarDialog() {
    if (this.bloodSugarDialogController) {
      this.bloodSugarDialogController.close()
      this.bloodSugarDialogController = undefined
    }
    this.bloodSugarDialogController = new CustomDialogController({
      builder: BloodSugarInputDialog({
        bloodSugarValue: this.bloodSugarVM!.value,
        onSubmit: (res) => {
          if (res) {
            this.updateBloodSugar(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.bloodSugarDialogController.open()
  }

  private showUricAcidDialog() {
    if (this.uricAcidDialogController) {
      this.uricAcidDialogController.close()
      this.uricAcidDialogController = undefined
    }
    this.uricAcidDialogController = new CustomDialogController({
      builder: UricAcidInputDialog({
        inputValue: this.uricAcidVM!.value,
        gender: this.userInfoVM!.gender,
        onSubmit: (res) => {
          if (res) {
            this.updateUricAcid(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.uricAcidDialogController.open()
  }

  private showBloodPressureDialog() {
    if (this.bloodPressDialogController) {
      this.bloodPressDialogController.close()
      this.bloodPressDialogController = undefined
    }
    this.bloodPressDialogController = new CustomDialogController({
      builder: BloodPressureInputDialog({
        systolicValue: this.bloodPressVM!.systolic,
        diastolicValue: this.bloodPressVM!.diastolic,
        onSubmit: (res) => {
          if (res) {
            this.updateBloodPressure(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.bloodPressDialogController.open()
  }

  private showBloodLipidDialog() {
    if (this.bloodLipidDialogController) {
      this.bloodLipidDialogController.close()
      this.bloodLipidDialogController = undefined
    }
    this.bloodLipidDialogController = new CustomDialogController({
      builder: BloodLipidInputDialog({
        totalCholesterol: this.bloodLipidVM!.totalCholesterol,
        triglycerides: this.bloodLipidVM!.triglycerides,
        hdlCholesterol: this.bloodLipidVM!.hdlCholesterol,
        ldlCholesterol: this.bloodLipidVM!.ldlCholesterol,
        onSubmit: (res) => {
          if (res) {
            this.updateBloodLipid(res)
          }
        }
      }),
      customStyle: true, // 关键参数：允许自定义样式
      alignment: this.dialogAlignment,
      offset: { dx: 0, dy: 0 },
      maskColor: ColorConstants.View_Mask,
      autoCancel: false,
    })
    this.bloodLipidDialogController.open()
  }

  build() {
    RelativeContainer() {
      // 滚动容器
      Scroll() {
        Column({ space: AppConstants.VIEW_SPACE }) {
          if (!this.isLoading) {
            // 基本信息卡片
            UserInfoCard({
              nickName: this.userInfoVM?.nickname,
              nAge: this.userInfoVM?.age,
              nGender: this.userInfoVM?.gender,
              nHeight: this.userInfoVM?.heightCm,
              handleClick: () => {
                this.showBaseInputDialog()
              }
            })
            // 健康指标网格
            Grid() {
              ForEach(this.getHealthCardData(), (cardData: HealthCardData, _: number) => {
                GridItem() {
                  HealthInfoCard({
                    data: cardData,
                    handleClick: (type) => {
                      const res = this.userInfoVM?.validateUserData()
                      if (res?.isValid) {
                        switch (type) {
                          case HealthCardDataType.WeightInfo: {
                            this.showWeightDialog()
                            break
                          }
                          case HealthCardDataType.BloodSugarInfo: {
                            this.showBloodSugarDialog()
                            break
                          }
                          case HealthCardDataType.UricAcidInfo: {
                            this.showUricAcidDialog()
                            break
                          }
                          case HealthCardDataType.BloodPressureInfo: {
                            this.showBloodPressureDialog()
                            break
                          }
                          case HealthCardDataType.BloodLipidInfo: {
                            this.showBloodLipidDialog()
                            break
                          }
                          default: {
                            break
                          }
                        }
                      } else {
                        showToast(this.getUIContext(), "请先输入用户信息")
                      }
                    }
                  })
                }
                .clickEffect({
                  level: ClickEffectLevel.HEAVY,
                  scale: 0.8
                })
                .onClick(() => {
                  const res = this.userInfoVM?.validateUserData()
                  if (res?.isValid) {
                    const data: Record<string, string> = {
                      "data": this.getTextByType(cardData.type)
                    }
                    getAppPathStack().pushPathByName("history", data, (res) => {
                      switch (res.result) {
                        case 'weight': {
                          this.showWeightDialog()
                          break;
                        }
                        case 'bloodSugar': {
                          this.showBloodSugarDialog()
                          break;
                        }
                        case 'uricAcid': {
                          this.showUricAcidDialog()
                          break;
                        }
                        case 'bloodPressure': {
                          this.showBloodPressureDialog()
                          break;
                        }
                        case 'bloodLipid': {
                          this.showBloodLipidDialog()
                          break;
                        }
                        default: {
                          break;
                        }
                      }
                    })
                  } else {
                    showToast(this.getUIContext(), "请先输入用户信息")
                  }
                })
              })
            }
            .width('100%')
            .height('100%')
            .nestedScroll({
              scrollForward: NestedScrollMode.PARENT_FIRST,
              scrollBackward: NestedScrollMode.SELF_FIRST
            })
            .padding({
              bottom: 24
            })
            .columnsTemplate(this.columnsTemplate)
            .rowsGap(AppConstants.VIEW_SPACE)
            .columnsGap(AppConstants.VIEW_SPACE)
            .scrollBar(BarState.Off)
            .onSizeChange((_: SizeOptions, newValue: SizeOptions) => {
              const curWidth = newValue.width
              const curHeight = newValue.height
              this.updateWindowSizeChange(curWidth, curHeight)
            })
          }
        }
        .padding(AppConstants.VIEW_PADDING)
        .justifyContent(FlexAlign.Start)
      }
      .backgroundColor(ColorConstants.View_Background_Color)
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .alignRules({
        top: { anchor: '__container__', align: VerticalAlign.Top },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
        left: { anchor: '__container__', align: HorizontalAlign.Start },
        right: { anchor: '__container__', align: HorizontalAlign.End }
      })

      // 遮罩背景半透明
      Column()
        .visibility(this.showExpandedButtons ? Visibility.Visible : Visibility.Hidden)
        .backgroundColor(ColorConstants.View_Mask)
        .alignRules({
          top: { anchor: '__container__', align: VerticalAlign.Top },
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .clickEffect({
          level: ClickEffectLevel.HEAVY,
          scale: 0.8
        })
        .onClick(() => {
          this.hideExpandedButtons()
        })

      // 发布按钮
      MIconButton({
        iconName: this.showExpandedButtons ? "x" : "+",
        iconColor: this.showExpandedButtons ? ColorConstants.Blue : ColorConstants.Red,
        handleClick: () => {
          if (this.showExpandedButtons) {
            // 关闭扩展按钮
            this.buttonScale = 0
            this.buttonOpacity = 0
            setTimeout(() => {
              this.showExpandedButtons = false
            }, 200)
          } else {
            // 显示扩展按钮
            this.showExpandedButtons = true
            setTimeout(() => {
              this.buttonScale = 1
              this.buttonOpacity = 1
            }, 10)
          }
        }
      })
        .visibility(this.showQuick ? Visibility.Visible : Visibility.Hidden)
        .id("__add_btn__")
        .alignRules({
          bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      ForEach(this.quickTools, (item: ToolItem, _) => {
        MIconButton({
          iconName: "",
          srcName: item.name,
          iconColor: ColorConstants.Blue,
          handleClick: () => {
            item.handleClick()
          }
        })
          .alignRules({
            center: { anchor: '__add_btn__', align: VerticalAlign.Center },
            middle: { anchor: '__add_btn__', align: HorizontalAlign.Center }
          })
          .margin({
            left: item.x,
            top: item.y,
          })
          .scale({ x: this.buttonScale, y: this.buttonScale })
          .opacity(this.buttonOpacity)
          .visibility(this.showExpandedButtons ? Visibility.Visible : Visibility.Hidden)
          .animation({
            duration: 300,
            curve: Curve.EaseOut
          })
      })
    }
  }
}