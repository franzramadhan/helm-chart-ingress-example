DROP TABLE IF EXISTS `test_table`;
CREATE TABLE IF NOT EXISTS `test_table` (
  `id` int(11) NOT NULL,   
  `uid` varchar(36) NOT NULL,       
  `coin_name` varchar(16)  NOT NULL default '',     
  `acronym`  varchar(16)  NOT NULL default '',
  `logo`  text  NOT NULL,   
   PRIMARY KEY  (`id`)
);
