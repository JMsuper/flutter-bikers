"use strict"

const sendResponse = (res, data, status = 200) => {
    return res.status(status).json(data);
};

module.exports = { sendResponse }; 