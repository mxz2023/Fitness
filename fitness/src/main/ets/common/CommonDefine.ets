/**
 * Copyright (c) 2023-2025 Mxz Co., Ltd.
 *
 * @file CommonDefine.ets
 * @project FitnessTracker
 * @author vincent_gemini
 * @crateTime 2025-09-25
 * @desc
 */

/**
 * 用户相关常量定义
 */
export class UserConstants {
  /**
   * 用户数据存储键名
   */
  static readonly USER_DATA_KEY: string = 'user_data';
  
  /**
   * 用户昵称最大长度
   */
  static readonly NICKNAME_MAX_LENGTH: number = 20;
  
  /**
   * 用户年龄最小值
   */
  static readonly AGE_MIN_VALUE: number = 1;
  
  /**
   * 用户年龄最大值
   */
  static readonly AGE_MAX_VALUE: number = 150;
  
  /**
   * 默认用户昵称
   */
  static readonly DEFAULT_NICKNAME: string = '用户';
  
  /**
   * 默认用户年龄
   */
  static readonly DEFAULT_AGE: number = 25;
  
  /**
   * 默认用户身高（厘米）
   */
  static readonly DEFAULT_HEIGHT_CM: number = 170;
}

export type HealthDataType = 'weight' | 'bloodPressure' | 'bloodLipid' | 'bloodSugar' | 'uricAcid';
