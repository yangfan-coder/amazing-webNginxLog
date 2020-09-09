const DataTypes = require('sequelize');
const Config = require('../config');

const logTable = Config.define('LogTableModel',
  {
    prject_id: {
      field: 'prject_id',
      type: DataTypes.STRING(255),
      allowNull: false
    },
    user_id: {
      field: 'user_id',
      type: DataTypes.STRING(255),
      allowNull: false
    },
    log_type: {
      field: 'log_type',
      type: DataTypes.INTEGER(64),
      allowNull: false
    },
    ua_info: {
      field: 'ua_info',
      type: DataTypes.STRING(1000),
      allowNull: false
    },
    date: {
      field: 'date',
      type: DataTypes.DATE,
      allowNull: false
    },
    key_name: {
      field: 'key_name',
      type: DataTypes.STRING(255),
      allowNull: false
    },
    key_self_info: {
      field: 'key_self_info',
      type: DataTypes.STRING(1000),
      allowNull: false
    },
    error_type: {
      field: 'error_type',
      type: DataTypes.INTEGER(64),
      allowNull: false
    },
    error_type_info: {
      field: 'error_type_info',
      type: DataTypes.STRING(1000),
      allowNull: false
    },
    error_stack_info: {
      field: 'error_stack_info',
      type: DataTypes.STRING(1000),
      allowNull: false
    },
    target_url: {
      field: 'target_url',
      type: DataTypes.STRING(1000),
      allowNull: false
    },
    key_id: {
      field: 'key_id',
      type: DataTypes.STRING(64),
      allowNull: false
    },
  },
  {
    timestamps: false,
    tableName: 'log_table'
  }
)
module.exports = logTable;
