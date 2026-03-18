### 파일별 INSERT 컬럼 비교

|컬럼|insert_goods_wet|insert_goods_wet_new|insert_goods_wet_homeplus|insert_goods_wet_ono|
|---|---|---|---|---|
|GOODS_WET_ID|✅|✅|✅|✅|
|GI_D_ID|✅|✅|✅|✅|
|WEIGHT|✅|✅|✅|✅|
|WEIGHT_UNIT|✅|✅|✅|✅|
|PACKER_PRODUCT_CODE|✅|✅|✅|✅|
|BARCODE|✅|✅|✅|✅|
|PACKER_CLIENT_CODE|✅|✅|✅|✅|
|MAKINGDATE|✅|✅|✅|✅|
|BOXSERIAL|✅|✅|✅|✅|
|BOX_CNT|✅|✅|✅|✅|
|REG_ID|✅|✅|✅|✅|
|REG_DATE|✅|✅|✅|✅|
|REG_TIME|✅|✅|✅|✅|
|**CHANNEL_CODE**|❌|❌|✅|❌|
|**BOX_ORDER**|❌|❌|✅|❌|


### 활성 UPDATE문 비교
### 비교표

| UPDATE 컬럼                      | 용도     | VIEW 조회 | 비고            |
| ------------------------------ | ------ | ------- | ------------- |
| **WHERE 조건**                   |        |         |               |
| GI_D_ID                        | 출고상세ID | ✅       | VIEW에서 조회     |
| ITEM_CODE                      | 상품코드   | ✅       | VIEW에서 조회     |
| BRAND_CODE                     | 브랜드코드  | ✅       | VIEW에서 조회     |
| **SET (update_shipment)**      |        |         |               |
| CHECK_YN                       | 체크여부   | ❌       | 고정값 'N'       |
| MOD_ID                         | 수정자ID  | ❌       | 안드로이드에서 전달    |
| MOD_DATE                       | 수정일자   | ❌       | 서버 시스템 날짜     |
| MOD_TIME                       | 수정시간   | ❌       | 서버 시스템 시간     |
| **SET (insert_goods_wet_ono)** |        |         |               |
| GI_QTY                         | 출고수량   | ❌       | 계근 중량 (안드로이드) |
| PACKING_QTY                    | 포장수량   | ❌       | 고정값 +1        |
| REG_ID                         | 등록자ID  | ❌       | 안드로이드에서 전달    |
| REG_DATE                       | 등록일자   | ❌       | 서버 시스템 날짜     |
| REG_TIME                       | 등록시간   | ❌       | 서버 시스템 시간     |
