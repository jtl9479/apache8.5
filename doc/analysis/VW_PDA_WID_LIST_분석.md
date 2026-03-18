# VW_PDA_WID_LIST VIEW 분석 문서

## 1. VIEW 개요

| 항목 | 내용 |
|------|------|
| VIEW명 | VW_PDA_WID_LIST |
| 스키마 | HIGHLAND |
| 용도 | 이마트 계근 사용 (PDA 출하 목록 조회) |
| 데이터베이스 | Oracle |

## 2. VIEW 역할

**이마트 출하 정보를 PDA에서 조회하기 위한 VIEW**

- 출고 요청 정보 (출고번호, 출하요청수량, 출하요청중량)
- 상품 정보 (상품코드, 상품명, 이마트상품코드)
- 거래처 정보 (점포코드, 점포명, 센터명)
- 이력 정보 (이력번호, 수입식별번호)
- 바코드 정보 (바코드타입, 바코드상품코드)

---

## 3. 사용 테이블 전체 목록

### 3.1 메인 테이블

| No | 테이블명 | 별칭 | 역할 | JOIN 타입 |
|----|----------|------|------|-----------|
| 1 | W_GOODS_IH | IH | 출고 헤더 | 메인 |
| 2 | W_GOODS_ID | ID | 출고 상세 | INNER JOIN |
| 3 | W_GOODS_R | WR | 입고 정보 | INNER JOIN |
| 4 | I_BL_D | BD | BL 상세 (해외매입) | INNER JOIN |
| 5 | I_OFFER_D | OD | 오퍼 상세 (국내매입) | INNER JOIN |
| 6 | B_ITEM | BI | 상품 마스터 | INNER JOIN |
| 7 | B_SUPPLIER_ITEM | BSI | 공급업체 상품 정보 | LEFT OUTER JOIN |
| 8 | W_EMART_ORDER_ITEM | EOI | 이마트 주문 상품 | INNER JOIN (서브쿼리) |
| 9 | B_EMART_BARCODE | EB | 이마트 바코드 | INNER JOIN (서브쿼리) |
| 10 | B_COMMON_CODE | BCC, BCC2, BC | 공통코드 | INNER JOIN / LEFT OUTER JOIN |
| 11 | S_BARCODE_INFO | A | 바코드 정보 | 서브쿼리 (SELECT) |

### 3.2 테이블별 사용 컬럼

#### W_GOODS_IH (출고 헤더) - 별칭: IH
| 컬럼명 | 용도 |
|--------|------|
| GI_H_ID | 출고헤더번호 |
| CLIENT_CODE | 출고업체코드 |
| GI_REQ_DATE | 출하요청일 |
| SEND_FLAG | 전송여부 (주석처리됨) |

#### W_GOODS_ID (출고 상세) - 별칭: ID
| 컬럼명 | 용도 |
|--------|------|
| GI_D_ID | 출고상세번호 |
| GI_H_ID | 출고헤더번호 (FK) |
| EOI_ID | 이마트주문번호 |
| ITEM_CODE | 상품코드 |
| BRAND_CODE | 브랜드코드 |
| GI_REQ_PKG | 출하요청수량 |
| GI_REQ_QTY | 출하요청중량 |
| AMOUNT | 금액 |
| GOODS_R_ID | 입고번호 (FK) |
| PACKING_QTY | 포장수량 |

#### W_GOODS_R (입고 정보) - 별칭: WR
| 컬럼명 | 용도 |
|--------|------|
| GOODS_R_ID | 입고번호 |
| GR_REF_NO | 창고입고번호 |
| BL_D_ID | BL상세번호 (FK) |
| BL_S_ID | BL시퀀스번호 (FK) |
| ITEM_SPEC | 상품스펙 |
| CT_CODE | 원산지코드 |
| IMPORT_ID_NO | 수입식별번호 |
| BL_NO | BL번호 |
| GR_WAREHOUSE_CODE | 입고창고코드 |
| CONTRACT_TYPE | 계약유형 (40: 국내매입) |

#### I_BL_D (BL 상세 - 해외매입) - 별칭: BD
| 컬럼명 | 용도 |
|--------|------|
| BL_D_ID | BL상세번호 |
| BL_S_ID | BL시퀀스번호 |
| PACKER_CODE | 패커코드 |
| PACKER_PRODUCT_CODE | 패커상품코드 |

#### I_OFFER_D (오퍼 상세 - 국내매입) - 별칭: OD
| 컬럼명 | 용도 |
|--------|------|
| OFFER_D_ID | 오퍼상세번호 |
| PACKER_CODE | 패커코드 |
| PACKER_PRODUCT_CODE | 패커상품코드 |

#### B_ITEM (상품 마스터) - 별칭: BI
| 컬럼명 | 용도 |
|--------|------|
| ITEM_CODE | 상품코드 |
| ITEM_TYPE | 상품유형 |
| MAJOR_CATEGORY | 축종 |
| CONTAINER_TYPE | 보관유형 (냉장/냉동) |

#### B_SUPPLIER_ITEM (공급업체 상품) - 별칭: BSI
| 컬럼명 | 용도 |
|--------|------|
| PACKER_CODE | 패커코드 |
| PACKER_PRODUCT_CODE | 패커상품코드 |
| EMART_PLANT_CODE | 이마트가공장코드 |

#### W_EMART_ORDER_ITEM (이마트 주문) - 별칭: EOI
| 컬럼명 | 용도 |
|--------|------|
| EOI_ID | 이마트주문번호 |
| STORE_NAME | 점포명 |
| STORE_CODE | 점포코드 |
| CENTER_CODE | 센터코드 |
| ITEM_CODE | 상품코드 |
| ITEM_NAME | 상품명 |
| STORE_IN_DATE | 점입점일자 |

#### B_EMART_BARCODE (이마트 바코드) - 별칭: EB
| 컬럼명 | 용도 |
|--------|------|
| EMARTITEM_CODE | 이마트상품코드 |
| BARCODE_TYPE | 바코드타입 |
| ITEM_TYPE | 상품유형 (W: 원료육) |
| PACKWEIGHT | 팩중량 |
| EMARTLOGIS_CODE | 이마트물류코드 |
| USE_CODE | 용도코드 |

#### B_COMMON_CODE (공통코드) - 별칭: BCC, BCC2, BC
| MASTER_CODE | 용도 |
|-------------|------|
| EMART_STORE_CODE | 이마트 점포코드 |
| HOMEPLUS_ORIGIN_CODE | 원산지코드 |
| EMART_RAWMEAT_USE_TYPE | 원료육 용도유형 |
| EMART_SCALE_BARCODE_USE_CENTER | 계근 바코드 사용 센터 |
| BRAND | 브랜드 |

#### S_BARCODE_INFO (바코드 정보) - 별칭: A
| 컬럼명 | 용도 |
|--------|------|
| PACKER_CLIENT_CODE | 패커코드 |
| PACKER_PRODUCT_CODE | 패커상품코드 |
| BARCODEGOODS | 바코드상품 |
| STATUS | 상태 |

---

## 4. 사용 함수

| 함수명 | 용도 |
|--------|------|
| DE_ITEM() | 상품코드로 상품명 조회 |
| DE_COMMON() | 공통코드로 코드명 조회 |
| DE_CLIENT() | 거래처코드로 거래처명 조회 |
| DE_CLIENT2() | 거래처코드로 거래처명2 조회 |
| DECODE() | 조건별 값 변환 |

---

## 5. VIEW 조건 (WHERE)

### 5.1 해외 매입 조건 (UNION 첫번째)
```sql
WHERE 1 = 1
  AND ID.PACKING_QTY = 0           -- 포장수량 0
  AND ID.GI_REQ_PKG <> 0           -- 출하요청수량 0이 아님
  AND WR.CONTRACT_TYPE <> '40'     -- 계약유형이 40(국내)이 아님
  AND EO.EOI_ID IS NOT NULL        -- 이마트주문번호 존재
  AND IH.GI_REQ_DATE >= TO_CHAR(SYSDATE,'YYYYMMDD')  -- 오늘 이후 출하요청일
```

### 5.2 국내 매입 조건 (UNION 두번째)
```sql
WHERE 1 = 1
  AND ID.PACKING_QTY = 0           -- 포장수량 0
  AND ID.GI_REQ_PKG <> 0           -- 출하요청수량 0이 아님
  AND WR.CONTRACT_TYPE = '40'      -- 계약유형이 40(국내)
  AND EO.EOI_ID IS NOT NULL        -- 이마트주문번호 존재
  AND IH.GI_REQ_DATE >= TO_CHAR(SYSDATE,'YYYYMMDD')  -- 오늘 이후 출하요청일
```

---

## 6. VIEW 구조

```
VW_PDA_WID_LIST
├── UNION ALL
│   ├── 해외 매입 (CONTRACT_TYPE <> '40')
│   │   ├── W_GOODS_IH (출고헤더)
│   │   ├── W_GOODS_ID (출고상세)
│   │   ├── W_GOODS_R (입고)
│   │   ├── I_BL_D (BL상세)
│   │   ├── B_SUPPLIER_ITEM (공급업체상품)
│   │   ├── B_ITEM (상품마스터)
│   │   └── EO 서브쿼리 (이마트주문)
│   │       ├── W_EMART_ORDER_ITEM
│   │       ├── B_EMART_BARCODE
│   │       └── B_COMMON_CODE (x3)
│   │
│   └── 국내 매입 (CONTRACT_TYPE = '40')
│       ├── W_GOODS_IH (출고헤더)
│       ├── W_GOODS_ID (출고상세)
│       ├── W_GOODS_R (입고)
│       ├── I_OFFER_D (오퍼상세)
│       ├── B_SUPPLIER_ITEM (공급업체상품)
│       ├── B_ITEM (상품마스터)
│       └── EO 서브쿼리 (이마트주문)
│           ├── W_EMART_ORDER_ITEM
│           ├── B_EMART_BARCODE
│           └── B_COMMON_CODE (x3)
```

---

## 7. 컬럼 상세 (41개)

| No | 컬럼명 | 데이터타입 | 설명 |
|----|--------|-----------|------|
| 1 | GI_H_ID | NUMBER | 출고번호(HEADER) |
| 2 | GI_D_ID | NUMBER | 출고번호(DETAIL) |
| 3 | EOI_ID | NUMBER(22) | 이마트 출고ID |
| 4 | ITEM_CODE | VARCHAR2(20) | 상품코드 |
| 5 | ITEM_NAME | VARCHAR2(32767) | 상품명 |
| 6 | EMARTITEM_CODE | VARCHAR2(20) | 이마트 상품코드 |
| 7 | EMARTITEM | VARCHAR2(50) | 이마트 상품명 |
| 8 | GI_REQ_PKG | NUMBER | 출하요청수량 |
| 9 | GI_REQ_QTY | NUMBER | 출하요청중량 |
| 10 | AMOUNT | NUMBER | 금액 |
| 11 | GOODS_R_ID | NUMBER | 입고번호 |
| 12 | GR_REF_NO | VARCHAR2(20) | 창고입고번호 |
| 13 | GI_REQ_DATE | CHAR(8) | 출하요청일 |
| 14 | BL_NO | VARCHAR2(50) | 이력번호 |
| 15 | BRAND_CODE | VARCHAR2(5) | 브랜드코드 |
| 16 | BRANDNAME | VARCHAR2(32767) | 브랜드명 |
| 17 | CLIENT_CODE | VARCHAR2(20) | 출고업체코드(점포코드) |
| 18 | CLIENTNAME | VARCHAR2(32767) | 출고업체명(점포명) |
| 19 | CENTERNAME | VARCHAR2(150) | 이마트 센터명 |
| 20 | ITEM_SPEC | VARCHAR2(3000) | 상품 스펙 |
| 21 | CT_CODE | VARCHAR2(5) | 원산지코드 |
| 22 | PACKER_CODE | VARCHAR2(30) | 패커 |
| 23 | IMPORT_ID_NO | VARCHAR2(50) | 수입식별번호(이력번호) |
| 24 | PACKERNAME | VARCHAR2(32767) | 패커명 |
| 25 | PACKER_PRODUCT_CODE | VARCHAR2(30) | 패커상품코드 |
| 26 | BARCODE_TYPE | VARCHAR2(10) | 바코드 타입 |
| 27 | ITEM_TYPE | VARCHAR2(1 CHAR) | W:원료육, J:제품, B:비정량 |
| 28 | PACKWEIGHT | VARCHAR2(20) | 팩중량(제품의 경우) |
| 29 | BARCODEGOODS | VARCHAR2(50) | 바코드 상품코드 |
| 30 | STORE_IN_DATE | CHAR(8) | 점입점일자 |
| 31 | GR_WAREHOUSE_CODE | VARCHAR2(20) | 입고창고코드 |
| 32 | EMARTLOGIS_CODE | VARCHAR2(50) | 이마트 물류 상품코드 |
| 33 | EMARTLOGIS_NAME | VARCHAR2(50) | 이마트 물류 상품명 |
| 34 | WH_AREA | VARCHAR2(50) | 이마트 창고코드 |
| 35 | USE_NAME | VARCHAR2(150) | 용도명 (국거리, 불고기 등) |
| 36 | USE_CODE | VARCHAR2(10) | 용도 코드 |
| 37 | CT_NAME | VARCHAR2(152) | 원산지명 |
| 38 | STORE_CODE | VARCHAR2(20) | 이마트 점포코드 |
| 39 | EMART_PLANT_CODE | VARCHAR2(20) | 이마트 가공장 코드 |
| 40 | MAJOR_CATEGORY | VARCHAR2(5) | 축종 |
| 41 | CONTAINER_TYPE | VARCHAR2(10) | 보관(냉장/냉동) |

---

## 8. 불필요해 보이는 구간

### 8.1 중복 가능성 있는 컬럼

| 컬럼 | 중복 의심 컬럼 | 비고 |
|------|---------------|------|
| ITEM_NAME | EMARTITEM | 둘 다 상품명 |
| BL_NO | IMPORT_ID_NO | 둘 다 이력번호 |
| CLIENT_CODE | STORE_CODE | 둘 다 점포코드 |

### 8.2 UNION ALL 중복 코드

- 해외 매입 / 국내 매입 쿼리가 대부분 동일
- I_BL_D vs I_OFFER_D 테이블만 다름
- 하나의 쿼리로 통합 가능 (CASE WHEN 또는 OUTER JOIN)

### 8.3 개선 제안

1. **VARCHAR2(32767)** 타입 컬럼들 - 실제 필요한 길이로 제한 검토
2. **DECODE 함수** - CASE WHEN으로 변경 시 가독성 향상
3. **서브쿼리 반복** - WITH절(CTE)로 공통화 가능

---

## 9. PDA 사용처

이 VIEW는 다음 JSP에서 사용될 가능성이 높음:

- `search_shipment.jsp` - 출하 조회
- `search_barcode_info.jsp` - 바코드 정보 조회

---

## 10. 참고사항

- Oracle VIEW이므로 현재 MSSQL 전환 시 문법 수정 필요
- DECODE → CASE WHEN 변환
- VARCHAR2 → VARCHAR 변환
- NUMBER → DECIMAL/INT 변환
- TO_CHAR(SYSDATE,'YYYYMMDD') → CONVERT(VARCHAR, GETDATE(), 112)

---

*문서 작성일: 2025-12-05*
