import React from "react";
import { ScrollView } from "react-native";
import { Header } from "../components/Header";
import { Days } from "../components/Days";
import { Section } from "../components/Section";
import { NextClass, Timeline, TaskStrip, Goal, Motivation } from "../components/HomeWidgets";
import { styles } from "../components/styles";

export function HomeScreen({day,setDay,done,toggle}:{day:string;setDay:(x:string)=>void;done:number[];toggle:(i:number)=>void}) {
  return <><Header/><Days selected={day} onSelect={setDay}/><NextClass/>
    <Section title="برنامه امروز" action="مشاهده همه"/><Timeline/>
    <TaskStrip done={done} toggle={toggle}/><Goal/><Motivation/>
  </>;
}
