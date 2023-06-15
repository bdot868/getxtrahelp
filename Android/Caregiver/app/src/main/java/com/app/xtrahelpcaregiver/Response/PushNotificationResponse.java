package com.app.xtrahelpcaregiver.Response;

public class PushNotificationResponse {
    public Messages messages;

    public Messages getMessages() {
        return messages;
    }

    public class Messages {
        public String unread;
        public String category;
        public MessageData messageData;

        public String getUnread() {
            return unread;
        }

        public String getCategory() {
            return category;
        }

        public MessageData getMessageData() {
            return messageData;
        }
    }
    

    public static class MessageData {
        String send_from;
        String send_to;
        String model_id;
        String model;
        String title;
        String desc;
        String amount;
        String jobName;

        public String getAmount() {
            return amount;
        }

        public String getJobName() {
            return jobName;
        }

        public String getSend_from() {
            return send_from;
        }

        public String getSend_to() {
            return send_to;
        }

        public String getModel_id() {
            return model_id;
        }

        public String getModel() {
            return model;
        }

        public String getTitle() {
            return title;
        }

        public String getDesc() {
            return desc;
        }
    }
}