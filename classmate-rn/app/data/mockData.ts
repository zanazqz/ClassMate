import { C } from "../theme/theme";

export type ClassItem = [string,string,string,string,string,string];
export type TaskItem = [string,string,string,string];

export const days = [["sat","ش","۱۲"],["sun","ی","۱۳"],["mon","د","۱۴"],["tue","س","۱۵"],["wed","چ","۱۶"],["thu","پ","۱۷"],["fri","ج","۱۸"]];
export const classes: ClassItem[] = [
  ["ساختمان داده","دکتر احمدی","۱۰:۳۰","کلاس ۲۰۴",C.cyan,"⌘"],
  ["سیستم عامل","مهندس رضایی","۱۳:۰۰","لابراتوار ۱",C.purple,"◈"],
  ["مهندسی نرم‌افزار","دکتر کریمی","۱۵:۳۰","کلاس ۱۰۷",C.green,"◉"]
];
export const tasks: TaskItem[] = [
  ["تحویل پروژه ساختمان داده","۲ روز مانده","پروژه",C.cyan],
  ["امتحان میان‌ترم سیستم عامل","۵ روز مانده","امتحان",C.orange],
  ["گزارش مهندسی نرم‌افزار","۷ روز مانده","تکلیف",C.purple]
];
