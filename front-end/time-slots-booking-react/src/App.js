import { Fragment, useState } from "react";
import axios from "axios";
import dayjs from "dayjs";

import { Button, DatePicker, message, Select, Form } from "antd";

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
  const [availableTimeSlots, setAvailableTimeSlots] = useState([]);
  const [messageApi, contextHolder] = message.useMessage();

  const handleDatePickerChange = (value) => {
    messageApi.info(
      `Selected Date: ${value ? value.format(dateFormat) : "None"}`
    );
  };

  const handleDurationSelectChange = (value) => {
    messageApi.info(
      `Selected Duration: ${value ? `${value} minutes` : "None"}`
    );
  };

  const onFormSubmit = (values) => {
    console.log("Success:", values);
    getAvailableTimeSlots(values);
  };

  const getAvailableTimeSlots = async ({ date, duration }) => {
    try {
      const response = await axios.get(
        `${process.env.REACT_APP_API_BASE_URL}/available_time_slots`,
        {
          params: {
            date: date.format(dateFormat),
            booking_duration: duration,
          },
        }
      );

      const timeSlots = response.data;
      console.log(timeSlots);
      setAvailableTimeSlots(timeSlots);
    } catch ({ response }) {
      const { errors } = response.data;
      Object.keys(errors).forEach((key) => {
        messageApi.error(`${key}: ${errors[key]}`);
      });
      console.log(errors);
    }
  };

  return (
    <Fragment className="App">
      <h1>Select desired date and duration</h1>
      {contextHolder}
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
    </Fragment>
  );
};

export default App;
