import { useState } from "react";
import { Button, DatePicker, message, Select, Form } from "antd";

import dayjs from "dayjs";

import "antd/dist/reset.css";

import "./App.css";

const { Option } = Select;
const dateFormat = "YYYY-MM-DD";

const generateDurationOptions = () => {
  let optionsArray = [];
  for (let i = 1; i <= 24; i++) {
    optionsArray.push(15 * i);
  }
  return optionsArray;
};
const possibleDurationOptions = generateDurationOptions();

const App = () => {
  const handleDatePickerChange = (value) => {
    message.info(`Selected Date: ${value ? value.format(dateFormat) : "None"}`);
  };

  const handleDurationSelectChange = (value) => {
    message.info(`Selected Duration: ${value ? `${value} minutes` : "None"}`);
  };

  const onFormSubmit = (values) => {
    console.log("Success:", values);
  };

  return (
    <div className="App">
      <h1>Select desired date and duration</h1>
      <Form
        labelCol={{
          span: 2,
        }}
        wrapperCol={{
          span: 10,
        }}
        initialValues={{
          date: dayjs(),
          duration: 15,
        }}
        onFinish={onFormSubmit}
      >
        <Form.Item label="Date:" name="date">
          <DatePicker onChange={handleDatePickerChange} format={dateFormat} />
        </Form.Item>
        <Form.Item label="Duration" name="duration">
          <Select onChange={handleDurationSelectChange}>
            {possibleDurationOptions.map((duration) => (
              <Option key={duration} value={duration}>
                {duration} minutes
              </Option>
            ))}
          </Select>
        </Form.Item>
        <Form.Item
          wrapperCol={{
            offset: 2,
            span: 16,
          }}
        >
          <Button type="primary" htmlType="submit">
            Search
          </Button>
        </Form.Item>
      </Form>
    </div>
  );
};

export default App;
