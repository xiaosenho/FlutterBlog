package org.example.blogserver.entity;

public enum Category {

    // 添加分类枚举值
    科技(1),
    娱乐(2),
    生活(3),
    旅行(4),
    互联网(5),
    经济(6)
    ;
    private final int value;
    Category(int value) {
        this.value = value;
    }
    public int value() {
        return this.value;
    }
}
