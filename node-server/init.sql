USE social_app;

-- users 테이블 (기본 사용자 정보)
CREATE TABLE users (
    id VARCHAR(50) PRIMARY KEY,  -- 문자열 ID 사용
    mobile_number VARCHAR(20) NOT NULL,
    nick_name VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(50) NOT NULL,
    role_id INT DEFAULT 0,
    sex CHAR(1),
    birth DATE,
    image_url VARCHAR(255)
);

-- friend 테이블 (팔로우/팔로워 관계)
CREATE TABLE friend (
    from_user VARCHAR(50) NOT NULL,
    to_user VARCHAR(50) NOT NULL,
    FOREIGN KEY (from_user) REFERENCES users(id),
    FOREIGN KEY (to_user) REFERENCES users(id),
    PRIMARY KEY (from_user, to_user)
);

-- feed 테이블 (게시물)
CREATE TABLE feed (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer_id VARCHAR(50) NOT NULL,
    contents TEXT,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    has_image BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (writer_id) REFERENCES users(id)
);

-- feed_image 테이블 (피드 이미지)
CREATE TABLE feed_image (
    feed_id BIGINT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    sequence INT NOT NULL,
    FOREIGN KEY (feed_id) REFERENCES feed(id) ON DELETE CASCADE,
    PRIMARY KEY (feed_id, sequence)
);

-- liked_feed 테이블 (피드 좋아요)
CREATE TABLE liked_feed (
    user_id VARCHAR(50) NOT NULL,
    feed_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (feed_id) REFERENCES feed(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, feed_id)
);

-- feed_comment 테이블 (피드 댓글)
CREATE TABLE feed_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer_id VARCHAR(50) NOT NULL,
    feed_id BIGINT NOT NULL,
    contents TEXT NOT NULL,
    like_count INT DEFAULT 0,
    comment_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (writer_id) REFERENCES users(id),
    FOREIGN KEY (feed_id) REFERENCES feed(id) ON DELETE CASCADE
);

-- feed_child_comment 테이블 (대댓글)
CREATE TABLE feed_child_comment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer_id VARCHAR(50) NOT NULL,
    feed_comment_id BIGINT NOT NULL,
    contents TEXT NOT NULL,
    like_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (writer_id) REFERENCES users(id),
    FOREIGN KEY (feed_comment_id) REFERENCES feed_comment(id) ON DELETE CASCADE
);

-- liked_feed_comment 테이블 (댓글 좋아요)
CREATE TABLE liked_feed_comment (
    user_id VARCHAR(50) NOT NULL,
    feed_comment_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (feed_comment_id) REFERENCES feed_comment(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, feed_comment_id)
);

-- liked_feed_child_comment 테이블 (대댓글 좋아요)
CREATE TABLE liked_feed_child_comment (
    user_id VARCHAR(50) NOT NULL,
    feed_child_comment_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (feed_child_comment_id) REFERENCES feed_child_comment(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, feed_child_comment_id)
);

-- goods_post 테이블 (상품 게시글)
CREATE TABLE goods_post (
    goods_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer_id VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    contents TEXT,
    price INT NOT NULL,
    like_count INT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    category_id INT NOT NULL,
    region_id INT NOT NULL,
    goods_state_id INT DEFAULT 1,
    FOREIGN KEY (writer_id) REFERENCES users(id)
);

-- goods_image 테이블 (상품 이미지)
CREATE TABLE goods_image (
    goods_id BIGINT NOT NULL,
    image_url VARCHAR(255) NOT NULL,
    sequence INT NOT NULL,
    FOREIGN KEY (goods_id) REFERENCES goods_post(goods_id) ON DELETE CASCADE,
    PRIMARY KEY (goods_id, sequence)
);

-- liked_goods 테이블 (상품 좋아요)
CREATE TABLE liked_goods (
    user_id VARCHAR(50) NOT NULL,
    goods_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (goods_id) REFERENCES goods_post(goods_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, goods_id)
);

-- tour_post 테이블 (투어 게시글)
CREATE TABLE tour_post (
    tour_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    writer_id VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    contents TEXT,
    region_lat DECIMAL(10,8) NOT NULL,
    region_lng DECIMAL(11,8) NOT NULL,
    start_date DATETIME NOT NULL,
    member_num INT NOT NULL,
    like_count INT DEFAULT 0,
    view_count INT DEFAULT 0,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (writer_id) REFERENCES users(id)
);

-- liked_tour 테이블 (투어 좋아요)
CREATE TABLE liked_tour (
    user_id VARCHAR(50) NOT NULL,
    tour_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (tour_id) REFERENCES tour_post(tour_id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, tour_id)
);