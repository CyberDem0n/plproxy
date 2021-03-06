create or replace function plproxy.get_cluster_version(cluster_name text)
returns integer as $$
begin
    if cluster_name = 'testcluster' then
        return 6;
    elsif cluster_name = 'map0' then
        return 1;
    elsif cluster_name = 'map1' then
        return 1;
    elsif cluster_name = 'map2' then
        return 1;
    elsif cluster_name = 'map3' then
        return 1;
    end if;
    raise exception 'no such cluster: %', cluster_name;
end; $$ language plpgsql;

create or replace function plproxy.get_cluster_partitions(cluster_name text)
returns setof text as $$
begin
    if cluster_name = 'testcluster' then
        return next 'host=127.0.0.1 dbname=test_part0';
        return next 'host=127.0.0.1 dbname=test_part1';
        return next 'host=127.0.0.1 dbname=test_part2';
        return next 'host=127.0.0.1 dbname=test_part3';
    elsif cluster_name = 'map0' then
        return next 'host=127.0.0.1 dbname=test_part0';
    elsif cluster_name = 'map1' then
        return next 'host=127.0.0.1 dbname=test_part1';
    elsif cluster_name = 'map2' then
        return next 'host=127.0.0.1 dbname=test_part2';
    elsif cluster_name = 'map3' then
        return next 'host=127.0.0.1 dbname=test_part3';
    else
        raise exception 'no such cluster: %', cluster_name;
    end if;
    return;
end; $$ language plpgsql;

create function map_cluster(part integer) returns text as $$
begin
    return 'map' || part;
end;
$$ language plpgsql;

create function test_clustermap(part integer) returns setof text as $$
    cluster map_cluster(part);
    run on 0;
    select current_database();
$$ language plproxy;

select * from test_clustermap(0);
select * from test_clustermap(1);
select * from test_clustermap(2);
select * from test_clustermap(3);

