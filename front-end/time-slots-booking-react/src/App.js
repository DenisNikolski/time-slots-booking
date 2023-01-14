import { Fragment, useState } from "react";
import axios from "axios";
import dayjs from "dayjs";
import utc from "dayjs/plugin/utc";

import {
  Button,
  DatePicker,
  message,
  Select,
  Form,
  Typography,
  Radio,
} from "antd";

import "antd/dist/reset.css";
import "./App.css";

const { Option } = Select;
const { Title } = Typography;
const dateFormat = "YYYY-MM-DD";
const api_base_url = process.env.REACT_APP_API_BASE_URL;

const generateDurationOptions = () => {
  let optionsArray = [];
  for (let i = 1; i <= 24; i++) {
    optionsArray.push(15 * i);
  }
  return optionsArray;
};
const possibleDurationOptions = generateDurationOptions();

const App = () => {
  const [availableTimeSlots, setAvailableTimeSlots] = useState();
  const [messageApi, contextHolder] = message.useMessage();
  dayjs.extend(utc);

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

  const onSearchFormSubmit = (values) => {
    console.log("Success:", values);
    getAvailableTimeSlots(values);
  };

  const onSelectFormSubmit = (values) => {
    console.log("Success:", values);
    createBooking(values);
  };

  const formatDateTimeToHours = (dateTime) => dayjs(dateTime).format("HH:mm");

  const displayApiErrors = (errors) => {
    Object.keys(errors).forEach((key) => {
      messageApi.error(`${key}: ${errors[key]}`);
    });
  };

  const getAvailableTimeSlots = async ({ date, duration }) => {
    try {
      const response = await axios.get(`${api_base_url}/available_time_slots`, {
        params: {
          date: dayjs.utc(date).format(dateFormat),
          booking_duration: duration,
        },
      });
      const timeSlots = response.data;
      console.log(timeSlots);
      setAvailableTimeSlots(timeSlots);
    } catch ({ response }) {
      const { errors } = response.data;
      displayApiErrors(errors);
      console.log(errors);
    }
  };

  const createBooking = async ({ timeSlot }) => {
    try {
      const response = await axios.post(`${api_base_url}/booked_time_slots`, {
        start: timeSlot.start,
        end: timeSlot.end,
      });
      const responseTimeSlot = response.data;
      console.log(responseTimeSlot);
      messageApi.success(
        ` Booked time slot: ${formatDateTimeToHours(
          responseTimeSlot.start
        )}-${formatDateTimeToHours(responseTimeSlot.end)}`
      );
      setAvailableTimeSlots(null);
    } catch ({ response }) {
      const { errors } = response.data;
      displayApiErrors(errors);
      console.log(errors);
    }
  };

  return (
    <div className="App">
      <Typography>
        <Title level={2}>Select desired date and duration</Title>
      </Typography>
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
        onFinish={onSearchFormSubmit}
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

      {availableTimeSlots && (
        <Fragment>
          <Title level={2}>Select Time Slot</Title>
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
            onFinish={onSelectFormSubmit}
          >
            <Form.Item
              wrapperCol={{
                offset: 2,
                span: 14,
              }}
            >
              <Form.Item
                label="Available time slots:"
                name="timeSlot"
                rules={[
                  { required: true, message: "Please select time slot!" },
                ]}
              >
                <Radio.Group>
                  {availableTimeSlots.map((timeSlot, index) => (
                    <Radio key={index} value={timeSlot}>
                      {formatDateTimeToHours(timeSlot.start)}-
                      {formatDateTimeToHours(timeSlot.end)}
                    </Radio>
                  ))}
                </Radio.Group>
              </Form.Item>
              <Button type="primary" htmlType="submit">
                Confirm Booking
              </Button>
            </Form.Item>
          </Form>
        </Fragment>
      )}
    </div>
  );
};

export default App;
