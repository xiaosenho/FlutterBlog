package org.example.blogserver;


import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.generator.FastAutoGenerator;
import com.baomidou.mybatisplus.generator.config.OutputFile;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.DbColumnType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import com.baomidou.mybatisplus.generator.fill.Column;

import java.sql.Types;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

//自定义模板生成
public class Generate {

    public static void main(String[] args) {
        String projectPath = System.getProperty("user.dir"); //获取当前项目路径


        FastAutoGenerator.create("jdbc:mysql://localhost:3306/shop?useUnicode=true&characterEncoding=utf-8&useSSL=true&allowMultiQueries=true",
                        "root",
                        "zxj123456")

                // 全局配置
                .globalConfig(builder -> {
                    builder
                            .author("xiaosenho") // 作者名称
                            .dateType(DateType.ONLY_DATE) // 时间策略
                            .commentDate("yyyy-MM-dd") // 注释日期
                            .outputDir(projectPath + "/src/main/java") // 输出目录
                            .disableOpenDir(); // 生成后禁止打开所生成的系统目录
                })
                //java和数据库字段的类型转换
                .dataSourceConfig(builder -> builder.typeConvertHandler((globalConfig, typeRegistry, metaInfo) -> {
                    int typeCode = metaInfo.getJdbcType().TYPE_CODE;
                    if (typeCode == Types.SMALLINT || typeCode == Types.TINYINT) {
                        // 自定义类型转换
                        return DbColumnType.INTEGER;
                    }
                    return typeRegistry.getColumnType(metaInfo);

                }))

                // 包配置
                .packageConfig(builder -> {
                    builder
                            .parent("org.example.blogserver") // 父包名
                            .moduleName("") // 父包模块名
                            .controller("controller")
                            .entity("entity") // 实体类包名
                            .service("service") // service包名
                            .serviceImpl("service.impl") // serviceImpl包名
                            .mapper("mapper") // mapper包名
                            .xml("mapper.xml")
                            .pathInfo(Collections.singletonMap(OutputFile.xml, projectPath + "/src/main/resources/generator/mapper/xml")).build();
                })

                // 策略配置
                .strategyConfig(builder -> {
                    builder.enableCapitalMode()//驼峰
                            .enableSkipView()//跳过视图
                            .disableSqlFilter()
                            .addInclude("collects")// 表匹配
//                            .addTablePrefix("t_") // 增加过滤表前缀
//                            .addTableSuffix("_db") // 增加过滤表后缀
//                            .addFieldPrefix("t_") // 增加过滤字段前缀
//                            .addFieldSuffix("_field") // 增加过滤字段后缀
//                            .addInclude("test") // 表匹配

                            // Entity 策略配置
                            .entityBuilder()
                            .enableFileOverride()
                            .enableLombok() // 开启lombok
                            .enableChainModel() // 链式
                            .enableRemoveIsPrefix() // 开启boolean类型字段移除is前缀
                            .enableTableFieldAnnotation() //开启生成实体时生成的字段注解
                            .versionColumnName("version") // 乐观锁数据库字段
                            .versionPropertyName("version") // 乐观锁实体类名称
//                            .logicDeleteColumnName("deleted") // 逻辑删除数据库中字段名
//                            .logicDeletePropertyName("deleted") // 逻辑删除实体类中的字段名
                            .naming(NamingStrategy.underline_to_camel) // 表名 下划线 -》 驼峰命名
                            .columnNaming(NamingStrategy.underline_to_camel) // 字段名 下划线 -》 驼峰命名
                            .idType(IdType.ASSIGN_ID) // 主键生成策略 雪花算法生成id
                            .formatFileName("%s") // Entity 文件名称
                            .addTableFills(new Column("create_time", FieldFill.INSERT)) // 表字段填充
                            .addTableFills(new Column("update_time", FieldFill.INSERT_UPDATE)) // 表字段填充
                            //.enableColumnConstant()
                            //.enableActiveRecord()//MPlus中启用ActiveRecord模式，生成的实体类会继承activerecord.Model类，直接进行数据库操作

                            // Controller 策略配置
                            .controllerBuilder()
                            .enableFileOverride()
                            .enableHyphenStyle()
                            .enableRestStyle() // 开启@RestController
                            .formatFileName("%sController") // Controller 文件名称

                            // Service 策略配置
                            .serviceBuilder()
                            .enableFileOverride()
                            .formatServiceFileName("%sService") // Service 文件名称
                            .formatServiceImplFileName("%sServiceImpl") // ServiceImpl 文件名称

                            // Mapper 策略配置
                            .mapperBuilder()
                            .enableFileOverride()
                            .enableMapperAnnotation() // 开启@Mapper
                            .enableBaseColumnList() // 启用 columnList (通用查询结果列)
                            .enableBaseResultMap() // 启动resultMap
                            .formatMapperFileName("%sMapper") // Mapper 文件名称
                            .formatXmlFileName("%sMapper"); // Xml 文件名称
                })
//                .templateEngine(new FreemarkerTemplateEngine()) // 使用Freemarker引擎模板，默认的是Velocity引擎模板
                .templateConfig(builder -> {
                    builder.controller("/templates/controller.java")
                            .service("/templates/service.java")
                            .serviceImpl("/templates/serviceImpl.java")
                            //.mapper()
                            .build();
                })

                .execute(); // 执行
    }
}


