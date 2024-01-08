package db

import (
	"database/sql"
	"fmt"

	_ "github.com/lib/pq"
	"github.com/m/go/utils"
)

var db *sql.DB

func InitDB() {
	var err error
	connStr := "postgres://viviviviviid:password@localhost/lending?sslmode=disable"
	db, err = sql.Open("postgres", connStr)
	utils.HandleErr(err)
	utils.HandleErr(db.Ping())
	fmt.Println("DB is connected")
}

func SignUp(addr string) {

	//
	// 예외처리 : 우선 SELECT로 확인해서 있으면 revert 및 login api 쏘도록 지시
	//

	result, err := db.Exec("INSERT INTO users(address) VALUES($1)", addr)
	utils.HandleErr(err)
	fmt.Println(result)
}

func SignIn(addr string) {

}
